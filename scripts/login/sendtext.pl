#!/usr/bin/perl -w

# send a string to android and finish it with the enter key
# (c) 2012 Andreas Ziermann

# "adb shell input text" is just a script file and does not handle
# containing a space very well 
use  File::Basename;

sub usage()
{
  print "send a string to android and finish it with the enter key\n\n";
  print "usage: ".basename($0)." <string>\n";
}

if (! defined $ARGV[0])
{
  usage();
  exit 1;
}

$text=$ARGV[0];

system("adb shell \"export CLASSPATH=/system/framework/input.jar; app_process /system/bin com.android.commands.input.Input text \\\"$text\\\"\"");
#system("adb shell input keyevent 66"); #66 -> KEYCODE_ENTER
