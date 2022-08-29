// TODO: Actually develop concrete visual design and put it here

import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

// A few constants to help really ensure we have visual consistency
const radius = 15.0;

// Text styling
// Equivalent to a <h1> element in HTML
const mainHeaderStyle = TextStyle(
  fontSize: 32, 
  fontWeight: FontWeight.w500,
  color: darkColour
);

// Equivalent to a <h2> element in HTML
const sectionHeaderStyle = TextStyle(
  fontSize: 24, 
  fontWeight: FontWeight.w400,
  color: darkColour
);

// Equivalent to a <h3> element in HTML
const subheaderStyle = TextStyle(
  fontSize: 20, 
  fontWeight: FontWeight.w800,
  color: darkColour
);

// Standard text, equivalent to a <p> element
const textStyle = TextStyle(
  fontSize: 20, 
  fontWeight: FontWeight.w400,
  color: darkColour
);

// Small, clear text for buttons or other UI elements
const buttonTextStyle = TextStyle(
  fontSize: 14, 
  fontWeight: FontWeight.w600,
  color: lightColour
);

// Smallish body text for modal elements
const modalTextStyle = TextStyle(
  fontSize: 16, 
  fontWeight: FontWeight.w400,
  color: darkColour
);

// Decorations for individual elements
BoxDecoration smallPlantComponent = BoxDecoration(
  color: accent,
  borderRadius: BorderRadius.circular(radius)
);

BoxDecoration smallPostComponent = BoxDecoration(
  color: mutedAccent,
  borderRadius: BorderRadius.circular(radius)
);


// Button styling
// Standard button
ButtonStyle buttonStyle = ButtonStyle(
  // shape: RoundedRectangleBorder(
  //   borderRadius: BorderRadius.circular(radius)
  // ), WHY DO YOU NOT WORK
  backgroundColor: MaterialStateProperty.all<Color>(secondaryAccent),
);

// Water-related button
ButtonStyle waterButtonStyle = ButtonStyle(
  // shape: RoundedRectangleBorder(
  //   borderRadius: BorderRadius.circular(radius)
  // ), WHY DO YOU NOT WORK
  backgroundColor: MaterialStateProperty.all<Color>(darkHighlight),
);