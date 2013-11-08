#!/bin/bash

salt-call state.show_lowstate
salt '*' state.highstate

