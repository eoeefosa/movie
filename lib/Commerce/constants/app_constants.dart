
//colors
import 'package:flutter/material.dart';

const mypurple = Color(0xFF4F0DA3);

//text

//url end points
const baseUrl = 'https://api.2geda.net';

//images
const String assets = 'assets/2geda/';
const whiteIcon = '$assets/2geda-logo.png';
const purpleIcon = '$assets/2geda-purple.png';
const bannerFifa = '$assets/banner2.png';
const banner3 = '$assets/banner3.png'; //fitimg
const music = '$assets/fitimg.png';

//onboarding screen head text
List<String> _headText = [
  'Connect with\nDiverse\nBusinesses',
  'Unlock Business \nand Personal \nPotentials',
  'Explore Our \nInclusive Business \nDirectory',
];

List<String> _subText = [
  'Boost local businesses on our app. \nConnect, engage, and grow \ntogether socially',
  'Meet prospective clients and \nvendors for your next product or \nservice needs',
  'Discover a diverse array of \nbusinesses in our inclusive directory \ntoday.',
];

List<String> searchTab = [
  'All',
  'People',
  'Jobs',
  'Media',
  'Business',
  'Places'
];

List<String> get headText => _headText;
List<String> get subText => _subText;

//text
const postText =
    'A widget that displays text with an option to show more or show less based on the provided settings.The RichReadMoreText widget allows you to trim text either based on the character length or the number of lines.When the text is longer than the specified trim length or exceeds the maximum number of lines, it provides a toggle option to show more or show less of the text.';
