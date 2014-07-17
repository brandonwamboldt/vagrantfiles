<?php

// Global
$cfg['CheckConfigurationPermissions'] = false;
$cfg['blowfish_secret']               = 'a8b7c6d';
$cfg['UploadDir']                     = '';
$cfg['SaveDir']                       = '';

// Server specific
$cfg['Servers'][1]['auth_type']       = 'config';
$cfg['Servers'][1]['user']            = 'root';
$cfg['Servers'][1]['password']        = '';
$cfg['Servers'][1]['host']            = 'localhost';
$cfg['Servers'][1]['connect_type']    = 'tcp';
$cfg['Servers'][1]['compress']        = false;
$cfg['Servers'][1]['extension']       = 'mysqli';
$cfg['Servers'][1]['AllowNoPassword'] = true;
