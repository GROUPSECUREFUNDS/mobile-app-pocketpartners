import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/group/group_response_model.dart';
import '../../../data/models/user_info/userinfo_response_model.dart';
import '../../../data/models/payment/payment_request_model.dart';
import '../../../shared/services/group_service.dart';
import '../../../shared/services/payment_service.dart';
import '../models/expense_entity.dart';
import '../services/expenses_service.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  int _currentStep = 0;
  GroupResponseModel? _selectedGroup;
  ExpenseModel? _selectedExpense;
  UserinfoResponseModel? _selectedMember;
  String _description = '';
  double _amount = 0.0;
  bool _isSubmitting = false;

  List<GroupResponseModel> _groups = [];
  List<ExpenseModel> _expenses = [];
  List<UserinfoResponseModel> _members = [];

  bool _loadingGroups = true;
  bool _loadingExpenses = false;
  bool _loadingMembers = false;
  String? _errorGroups;
  String? _errorExpenses;
  String? _errorMembers;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _loadingGroups = true;
      _errorGroups = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) throw Exception('Usuario no identificado');
      final groups = await GroupService().getGroupsByUserId(int.parse(userId));
      setState(() {
        _groups = groups;
        _loadingGroups = false;
      });
    } catch (e) {
      setState(() {
        _errorGroups = e.toString();
        _loadingGroups = false;
      });
    }
  }

  Future<void> _fetchExpenses() async {
    if (_selectedGroup == null) return;
    setState(() {
      _loadingExpenses = true;
      _errorExpenses = null;
      _expenses = [];
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) throw Exception('Usuario no identificado');
      final data = await ExpensesService().getExpensesByGroupId(_selectedGroup!.id);
      final expenses = (data as List)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .where((expense) => expense.userId == int.parse(userId))
          .toList();
      setState(() {
        _expenses = expenses;
        _loadingExpenses = false;
      });
    } catch (e) {
      setState(() {
        _errorExpenses = e.toString();
        _loadingExpenses = false;
      });
    }
  }

  Future<void> _fetchMembers() async {
    if (_selectedGroup == null) return;
    setState(() {
      _loadingMembers = true;
      _errorMembers = null;
      _members = [];
    });
    try {
      final data = await GroupService().getMembersByGroupId(_selectedGroup!.id);
      setState(() {
        _members = data;
        _loadingMembers = false;
      });
    } catch (e) {
      setState(() {
        _errorMembers = e.toString();
        _loadingMembers = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) throw Exception('Usuario no identificado');
      final payment = PaymentRequestModel(
        description: _description,
        amount: _amount,
        status: 'pending',
        userId: _selectedMember!.userId,
        expenseId: _selectedExpense!.id,
      );
      await PaymentService().createPayment(payment);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago: $e')),
      );
    }
  }

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
        title: const Text('Grupo'),
        content: _loadingGroups
            ? const CircularProgressIndicator()
            : _errorGroups != null
            ? Text('Error: $_errorGroups')
            : DropdownButtonFormField<GroupResponseModel>(
          value: _selectedGroup,
          items: _groups
              .map((g) => DropdownMenuItem(
            value: g,
            child: Text(g.name),
          ))
              .toList(),
          onChanged: (g) {
            setState(() {
              _selectedGroup = g;
              _selectedExpense = null;
              _selectedMember = null;
            });
            _fetchExpenses();
            _fetchMembers();
          },
          decoration: const InputDecoration(labelText: 'Selecciona un grupo'),
          validator: (v) => v == null ? 'Seleccione un grupo' : null,
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Expense'),
        content: _loadingExpenses
            ? const CircularProgressIndicator()
            : _errorExpenses != null
            ? Text('Error: $_errorExpenses')
            : DropdownButtonFormField<ExpenseModel>(
          value: _selectedExpense,
          items: _expenses
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.name),
          ))
              .toList(),
          onChanged: (e) => setState(() => _selectedExpense = e),
          decoration: const InputDecoration(labelText: 'Selecciona un gasto'),
          validator: (v) => v == null ? 'Seleccione un gasto' : null,
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Miembro'),
        content: _loadingMembers
            ? const CircularProgressIndicator()
            : _errorMembers != null
            ? Text('Error: $_errorMembers')
            : DropdownButtonFormField<UserinfoResponseModel>(
          value: _selectedMember,
          items: _members
              .map((m) => DropdownMenuItem(
            value: m,
            child: Text('${m.firstName} ${m.lastName}'),
          ))
              .toList(),
          onChanged: (m) => setState(() => _selectedMember = m),
          decoration: const InputDecoration(labelText: 'Selecciona un miembro'),
          validator: (v) => v == null ? 'Seleccione un miembro' : null,
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Detalles del Pago'),
        content: Column(
          children: [
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (v) => (v == null || v.isEmpty) ? 'Ingrese una descripción' : null,
              onChanged: (v) => setState(() => _description = v),
            ),
            TextFormField(
              initialValue: _amount == 0.0 ? '' : _amount.toString(),
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingrese un monto';
                final value = double.tryParse(v);
                if (value == null || value <= 0) return 'Monto inválido';
                return null;
              },
              onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0.0),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Resumen'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grupo: ${_selectedGroup?.name ?? ''}'),
            Text('Expense: ${_selectedExpense?.name ?? ''}'),
            Text('Miembro: ${_selectedMember != null ? '${_selectedMember!.firstName} ${_selectedMember!.lastName}' : ''}'),
            Text('Descripción: $_description'),
            Text('Monto: \$${_amount.toStringAsFixed(2)}'),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _selectedGroup != null;
      case 1:
        return _selectedExpense != null;
      case 2:
        return _selectedMember != null;
      case 3:
        return _description.isNotEmpty && _amount > 0;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Pago')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          steps: _buildSteps(context),
          onStepContinue: () {
            if (_currentStep < 4) {
              if (_canContinue()) {
                setState(() => _currentStep += 1);
              } else {
                _formKey.currentState?.validate();
              }
            } else {
              if (!_isSubmitting) _submit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep -= 1);
          },
          controlsBuilder: (context, details) {
            final isLast = _currentStep == 4;
            return Row(
              children: [
                ElevatedButton(
                  onPressed: _canContinue() && !_isSubmitting
                      ? details.onStepContinue
                      : null,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(isLast ? 'Submit' : 'Next'),
                ),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: !_isSubmitting ? details.onStepCancel : null,
                    child: const Text('Back'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}