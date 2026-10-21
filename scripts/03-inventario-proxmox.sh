#!/usr/bin/env bash
# Solo lectura; ejecutar en host Proxmox.
set -u
echo '=== VMs ==='
qm list
echo '=== GNS3 ==='
qm config 100 | grep -E '^(name|net[0-9]+):'
echo '=== WINDOWS ==='
qm config 150 | grep -E '^(name|net[0-9]+):'
echo '=== BRIDGES ==='
ip -br link show type bridge
echo '=== PUERTOS ==='
bridge link show
echo '=== ALMACENAMIENTO ==='
pvesm status
