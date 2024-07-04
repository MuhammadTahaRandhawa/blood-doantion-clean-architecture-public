bool isDonationAllowed(String donor, String recipient) {
  // Defining the compatibility rules
  Map<String, List<String>> compatibility = {
    'O-': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
    'O+': ['O+', 'A+', 'B+', 'AB+'],
    'A-': ['A-', 'A+', 'AB-', 'AB+'],
    'A+': ['A+', 'AB+'],
    'B-': ['B-', 'B+', 'AB-', 'AB+'],
    'B+': ['B+', 'AB+'],
    'AB-': ['AB-', 'AB+'],
    'AB+': ['AB+']
  };

  // Checking if the recipient's blood group is in the donor's compatibility list
  if (compatibility.containsKey(donor)) {
    return compatibility[donor]!.contains(recipient);
  }
  return false; // Return false if the donor blood group is not valid
}
