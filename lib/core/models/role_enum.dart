enum UserRole {
  resident(
    code: 'RES',
    label: 'Resident',
    description: 'Pay dues, invite visitors, raise complaints & book amenities',
  ),
  admin(
    code: 'ADM',
    label: 'Society Admin',
    description: 'User HR management, roles, society settings & audit log',
  ),
  manager(
    code: 'MGR',
    label: 'Estate Manager',
    description: 'Complaint queue, staff dispatch & booking approvals',
  ),
  accountant(
    code: 'ACT',
    label: 'Accountant',
    description: 'Bill generation, collections ledger, expenses & P&L reports',
  ),
  committee(
    code: 'CMT',
    label: 'Committee Member',
    description: 'Governance polls, AGM meetings & executive reports',
  ),
  guard(
    code: 'GRD',
    label: 'Security Guard',
    description: 'QR gate entry, walk-in approvals & vehicle checks',
  );

  final String code;
  final String label;
  final String description;

  const UserRole({
    required this.code,
    required this.label,
    required this.description,
  });

  static UserRole fromCode(String code) {
    return UserRole.values.firstWhere(
      (r) => r.code == code || r.name == code,
      orElse: () => UserRole.resident,
    );
  }
}
