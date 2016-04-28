package Foswiki::Plugins::QueryVersionPlugin;

use strict;
use warnings;

use version;
our $VERSION = version->declare('1.0.0');
our $RELEASE = '1.0.0';
our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = 'Queries plugins and contribs and returns their version.';

sub initPlugin {
  my ($topic, $web, $user, $installWeb) = @_;

  if ($Foswiki::Plugins::VERSION < 2.0) {
    Foswiki::Func::writeWarning( 'Version mismatch between ',
      __PACKAGE__, ' and Plugins.pm' );
    return 0;
  }

  Foswiki::Func::registerTagHandler('QUERYVERSION', \&_QUERY);
  return 1;
}

sub _QUERY {
  my( $session, $params, $topic, $web, $topicObject ) = @_;

  my $name = $params->{_DEFAULT} || $params->{name} || '';
  return '' unless $name;
  
  my $version;
  my $format = $params->{format} || '';
  unless ($name =~ /(Contrib|Skin)$/) {
    return '' unless ref($Foswiki::cfg{Plugins}{$name}) eq 'HASH';
    if ($Foswiki::cfg{Plugins}{$name}{Enabled}) {
      return _format($Foswiki::cfg{Plugins}{$name}{Module}->VERSION, $format);
    }

    eval {
      my $mod = "$Foswiki::cfg{Plugins}{$name}{Module}.pm";
      $mod =~ s/::/\//g;
      require $mod;
      $version = _format($Foswiki::cfg{Plugins}{$name}{Module}->VERSION, $format);
      1;
    };

    Foswiki::Func::writeWarning(
      "Unable to find VERSION string for given plugin name '$name'"
    ) unless $version;

    return $version || '';
  }

  eval {
    my $contrib = "Foswiki/Contrib/$name.pm";
    require $contrib;
    my $mod = "Foswiki::Contrib::$name";
    $version = _format($mod->VERSION, $format) if $mod->VERSION;
    1;
  };

  $version || '';
}

sub _format {
  my ($version, $format) = @_;
  return $version unless $format;
  $format =~ s/\$version/$version/g;
  return $format;
}

1;

__END__
Q.Wiki Tasks API - Modell Aachen GmbH

Author: %$AUTHOR%

Copyright (C) 2016 Modell Aachen GmbH

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
