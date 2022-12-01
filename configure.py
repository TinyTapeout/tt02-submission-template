#!/usr/bin/env python3
import requests
import argparse
import os
import yaml
import logging
import sys
import csv
import re
import subprocess


def load_yaml(yaml_file):
    with open(yaml_file, "r") as stream:
        return (yaml.safe_load(stream))


def write_user_config(module_name, sources):
    filename = 'user_config.tcl'
    with open(os.path.join('src', filename), 'w') as fh:
        fh.write("set ::env(DESIGN_NAME) {}\n".format(module_name))
        fh.write('set ::env(VERILOG_FILES) "\\\n')
        for line, source in enumerate(sources):
            fh.write("    $::env(DESIGN_DIR)/" + source)
            if line != len(sources) - 1:
                fh.write(' \\\n')
        fh.write('"\n')


def fetch_file(url, filename):
    logging.info("trying to download {}".format(url))
    r = requests.get(url)
    if r.status_code != 200:
        logging.warning("couldn't download {}".format(url))
        exit(1)

    with open(filename, 'wb') as fh:
        logging.info("written to {}".format(filename))
        fh.write(r.content)


def get_project_source(yaml):
    # wokwi_id must be an int or 0
    try:
        wokwi_id = int(yaml['project']['wokwi_id'])
    except ValueError:
        logging.error("wokwi id must be an integer")
        exit(1)

    # it's a wokwi project
    if wokwi_id != 0:
        url = "https://wokwi.com/api/projects/{}/verilog".format(wokwi_id)
        src_file = "user_module_{}.v".format(wokwi_id)
        fetch_file(url, os.path.join("src", src_file))

        # also fetch the wokwi diagram
        url = "https://wokwi.com/api/projects/{}/diagram.json".format(wokwi_id)
        diagram_file = "wokwi_diagram.json"
        fetch_file(url, os.path.join("src", diagram_file))

        return [src_file, 'cells.v']

    # else it's HDL, so check source files
    else:
        if 'source_files' not in yaml['project']:
            logging.error("source files must be provided if wokwi_id is set to 0")
            exit(1)

        source_files = yaml['project']['source_files']
        if source_files is None:
            logging.error("must be more than 1 source file")
            exit(1)

        if len(source_files) == 0:
            logging.error("must be more than 1 source file")
            exit(1)

        if 'top_module' not in yaml['project']:
            logging.error("must provide a top module name")
            exit(1)

        for filename in source_files:
            if not os.path.exists(os.path.join('src', filename)):
                logging.error(f"{filename} doesn't exist in the repo")
                exit(1)

        return source_files


# documentation
def check_docs(yaml):
    for key in ['author', 'title', 'description', 'how_it_works', 'how_to_test', 'language']:
        if key not in yaml['documentation']:
            logging.error("missing key {} in documentation".format(key))
            exit(1)
        if yaml['documentation'][key] == "":
            logging.error("missing value for {} in documentation".format(key))
            exit(1)

    # if provided, check discord handle is valid
    if len(yaml['documentation']['discord']):
        parts = yaml['documentation']['discord'].split('#')
        if len(parts) != 2 or len(parts[0]) == 0 or not re.match('^[0-9]{4}$', parts[1]):
            logging.error('Invalid format for discord username')
            exit(1)


def build_pdf(yaml_data):
    with open(".github/workflows/doc_header.md") as fh:
        doc_header = fh.read()
    with open(".github/workflows/doc_preview.md") as fh:
        doc_template = fh.read()

    with open('datasheet.md', 'w') as fh:
        fh.write(doc_header)
        # handle pictures
        yaml_data['picture_link'] = ''
        if yaml_data['picture']:
            # skip SVG for now, not supported by pandoc
            picture_name = yaml_data['picture']
            if 'svg' not in picture_name:
                yaml_data['picture_link'] = '![picture]({})'.format(picture_name)
            else:
                logging.warning("svg not supported")

        # now build the doc & print it
        try:
            doc = doc_template.format(**yaml_data)
            fh.write(doc)
            fh.write("\n\pagebreak\n")
        except IndexError:
            logging.warning("missing pins in info.yaml, skipping")

    pdf_cmd = 'pandoc --pdf-engine=xelatex -i datasheet.md -o datasheet.pdf'
    logging.info(pdf_cmd)
    p = subprocess.run(pdf_cmd, shell=True)
    if p.returncode != 0:
        logging.error("pdf command failed")


def get_top_module(yaml):
    wokwi_id = int(yaml['project']['wokwi_id'])
    if wokwi_id != 0:
        return "user_module_{}".format(wokwi_id)
    else:
        return yaml['project']['top_module']


def get_stats():
    with open('runs/wokwi/reports/metrics.csv') as f:
        report = list(csv.DictReader(f))[0]

    print('# Routing stats')
    print()
    print('| Utilisation | Wire length (um) |')
    print('|-------------|------------------|')
    print('| {} | {} |'.format(report['OpenDP_Util'], report['wire_length']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="TT setup")

    parser.add_argument('--check-docs', help="check the documentation part of the yaml", action="store_const", const=True)
    parser.add_argument('--build-pdf', help="build a single page PDF", action="store_const", const=True)
    parser.add_argument('--get-stats', help="print some stats from the run", action="store_const", const=True)
    parser.add_argument('--create-user-config', help="create the user_config.tcl file with top module and source files", action="store_const", const=True)
    parser.add_argument('--debug', help="debug logging", action="store_const", dest="loglevel", const=logging.DEBUG, default=logging.INFO)
    parser.add_argument('--yaml', help="yaml file to load", default='info.yaml')

    args = parser.parse_args()
    # setup log
    log_format = logging.Formatter('%(asctime)s - %(module)-10s - %(levelname)-8s - %(message)s')
    # configure the client logging
    log = logging.getLogger('')
    # has to be set to debug as is the root logger
    log.setLevel(args.loglevel)

    # create console handler and set level to info
    ch = logging.StreamHandler(sys.stdout)
    # create formatter for console
    ch.setFormatter(log_format)
    log.addHandler(ch)

    if args.get_stats:
        get_stats()

    elif args.check_docs:
        logging.info("checking docs")
        config = load_yaml(args.yaml)
        check_docs(config)

    elif args.build_pdf:
        logging.info("building pdf")
        config = load_yaml(args.yaml)
        build_pdf(config['documentation'])

    elif args.create_user_config:
        logging.info("creating include file")
        config = load_yaml(args.yaml)
        source_files = get_project_source(config)
        top_module = get_top_module(config)
        if top_module == 'top':
            logging.error("top module cannot be called top - prepend your repo name to make it unique")
            exit(1)
        write_user_config(top_module, source_files)
