enum UserRole {
  superAdmin(
    roleId: 0,
    code: 'SUP',
    label: 'Super Admin',
    description: 'Platform owner & multi-society management',
  ),
  admin(
    roleId: 1,
    code: 'ADM',
    label: 'Society Admin',
    description: 'User HR management, roles, society settings & audit log',
  ),
  manager(
    roleId: 2,
    code: 'MGR',
    label: 'Estate Manager',
    description: 'Complaint queue, staff dispatch, gate pass scan & booking approvals',
  ),
  resident(
    roleId: 3,
    code: 'RES',
    label: 'Resident',
    description: 'Pay dues, invite visitors, raise complaints & book amenities',
  ),
  accountant(
    roleId: 4,
    code: 'ACT',
    label: 'Accountant',
    description: 'Bill generation, collections ledger, expenses & P&L reports',
  ),
  committee(
    roleId: 5,
    code: 'CMT',
    label: 'Committee Member',
    description: 'Governance polls, AGM meetings & executive reports',
  ),
  guard(
    roleId: 6,
    code: 'GRD',
    label: 'Security Guard',
    description: 'QR gate entry scan, walk-in approvals & vehicle checks',
  );

  final int roleId;
  final String code;
  final String label;
  final String description;

  const UserRole({
    required this.roleId,
    required this.code,
    required this.label,
    required this.description,
  });

  static UserRole fromRoleId(dynamic rawRoleId, [String? rawRole]) {
    if (rawRoleId != null) {
      final idStr = rawRoleId.toString().trim();
      if (idStr == '0') return UserRole.superAdmin;
      if (idStr == '1') return UserRole.admin;
      if (idStr == '2') return UserRole.manager;
      if (idStr == '3') return UserRole.resident;
      if (idStr == '4') return UserRole.accountant;
      if (idStr == '5') return UserRole.committee;
      if (idStr == '6') return UserRole.guard;
    }
    if (rawRole != null) {
      return fromCode(rawRole);
    }
    return UserRole.resident;
  }

  static UserRole fromCode(String rawRole) {
    final lower = rawRole.trim().toLowerCase();
    if (lower == 'superadmin' || lower == 'super_admin' || lower == 'sup') {
      return UserRole.superAdmin;
    }
    if (lower == 'owner' || lower == 'admin' || lower == 'adm') {
      return UserRole.admin;
    }
    if (lower == 'manager' || lower == 'mgr') {
      return UserRole.manager;
    }
    if (lower == 'tenant' || lower == 'resident' || lower == 'res') {
      return UserRole.resident;
    }
    if (lower == 'accountant' || lower == 'act') {
      return UserRole.accountant;
    }
    if (lower == 'committee' || lower == 'cmt') {
      return UserRole.committee;
    }
    if (lower == 'guard' || lower == 'grd') {
      return UserRole.guard;
    }
    return UserRole.values.firstWhere(
      (r) => r.code.toLowerCase() == lower || r.name.toLowerCase() == lower,
      orElse: () => UserRole.resident,
    );
  }
}
