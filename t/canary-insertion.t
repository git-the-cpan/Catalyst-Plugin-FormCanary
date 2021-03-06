#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use Test::More tests => 9;
use Test::WWW::Mechanize::Catalyst 't::lib::TestApp';

my $basic_form = t::lib::TestApp::Controller::Root::basic_form();
ok($basic_form, 'got the basic form (duh)');

my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://whatever/not_html');
is($mech->content, $basic_form, 'not_html is not modified');

$mech->get_ok('http://whatever/one_form');
isnt($mech->content, $basic_form, 'one_form is modified');
$mech->content_like(qr/name="canary_[^"]+"/, 'contains canary');

my $two_basic_forms = t::lib::TestApp::Controller::Root::two_basic_forms();
$mech->get_ok('http://whatever/two_forms');
isnt($mech->content, $two_basic_forms, 'two_forms is modified');
$mech->content_like(qr{(name="canary_[^"]+").*\1}s,'contains 2 canaries');
