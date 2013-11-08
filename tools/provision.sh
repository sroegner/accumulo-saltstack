#!/bin/bash

salt-call state.show_lowstate
salt '*' saltutil.sync_all
salt '*' state.highstate

