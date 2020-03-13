#!/bin/bash
nova $1 smartdatacluster-hdp-bi
nova $1 smartdatacluster-hdp-master
nova $1 smartdatacluster-hdp-slave-01
nova $1 smartdatacluster-hdp-slave-02
nova $1 smartdatacluster-hdp-stream
watch -n 10 nova list