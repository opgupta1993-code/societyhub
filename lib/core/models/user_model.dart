import 'role_enum.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String societyName;
  final String blockFlat;
  final int roleId; // 1 = Admin/Owner, 2 = Tenant
  final bool isOwner; // true = Owner (role_id 1), false = Tenant (role_id 2)
  final UserRole activeRole;
  final List<UserRole> availableRoles;
  final String? profilePhotoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.societyName,
    required this.blockFlat,
    this.roleId = 2,
    this.isOwner = false,
    required this.activeRole,
    required this.availableRoles,
    this.profilePhotoUrl,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? societyName,
    String? blockFlat,
    int? roleId,
    bool? isOwner,
    UserRole? activeRole,
    List<UserRole>? availableRoles,
    String? profilePhotoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      societyName: societyName ?? this.societyName,
      blockFlat: blockFlat ?? this.blockFlat,
      roleId: roleId ?? this.roleId,
      isOwner: isOwner ?? this.isOwner,
      activeRole: activeRole ?? this.activeRole,
      availableRoles: availableRoles ?? this.availableRoles,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  static UserModel dummyUser() {
    return const UserModel(
      id: 'usr_001',
      name: 'Rajesh Sharma',
      phone: '+91 98765 43210',
      societyName: 'Greenwood Heights CHS',
      blockFlat: 'Tower A - 402',
      roleId: 2,
      isOwner: false,
      activeRole: UserRole.resident,
      availableRoles: [
        UserRole.resident,
        UserRole.admin,
        UserRole.manager,
        UserRole.accountant,
        UserRole.committee,
        UserRole.guard,
      ],
    );
  }
}
