class BloodGroup {
  final String name;

  BloodGroup(this.name);

  static List<BloodGroup> getBloodGroupList() {
    return [
      BloodGroup('A+'),
      BloodGroup('A-'),
      BloodGroup('B+'),
      BloodGroup('B-'),
      BloodGroup('O+'),
      BloodGroup('O-'),
      BloodGroup('AB+'),
      BloodGroup('AB-')
    ];
  }
}
