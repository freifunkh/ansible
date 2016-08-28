#!/bin/bash

gpg -d secrets.asc | tar -x
