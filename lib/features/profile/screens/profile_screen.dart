import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/shared/services/partner_service.dart';
import 'package:mobile_app_pocketpartners/data/models/partner/partner_response_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = AuthController();
  final partnerService = PartnerService();

  PartnerResponseModel? partner;
  bool _isLoading = true;
  bool _isEnglish = true;

  @override
  void initState() {
    super.initState();
    _loadPartnerData();
  }

  Future<void> _loadPartnerData() async {
    final user = await authController.getUserFromPreferences();
    if (user != null) {
      final partnerData = await partnerService.getPartnerById(user.id);
      setState(() {
        partner = partnerData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = _isEnglish
        ? ["Full Name", "Email", "Phone"]
        : ["Nombre completo", "Correo", "Teléfono"];

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: -80,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          "assets/images/bg_draw.jpg",
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -55,
                  child: GestureDetector(
                    onTap: () {
                      context.push("/profile/edit");
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: partner?.photo != null &&
                              partner!.photo!.isNotEmpty
                              ? NetworkImage(partner!.photo!)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: partner?.photo == null || partner!.photo!.isEmpty
                              ? const Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                        const CircleAvatar(

                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(
                              Icons.edit, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),

            // Adjust space so avatar doesn’t get cut
            const SizedBox(height: 55),

            // Profile Card
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 00),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildInfoField(labels[0], partner?.fullName ?? ""),
                  const SizedBox(height: 18),
                  _buildInfoField(labels[1], partner?.email ?? ""),
                  const SizedBox(height: 18),
                  _buildInfoField(labels[2], partner?.phoneNumber ?? ""),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEnglish
                            ? "Display in English"
                            : "Mostrar en Español",
                        style:
                        const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Switch(
                        value: _isEnglish,
                        onChanged: (val) => setState(() => _isEnglish = val),
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
