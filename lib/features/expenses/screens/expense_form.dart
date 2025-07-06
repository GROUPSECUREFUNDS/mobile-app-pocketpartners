import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../data/models/group/group_response_model.dart';
import '../../../shared/services/group_service.dart';
import '../services/expenses_service.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _amount = 0.0;
  GroupResponseModel? _selectedGroup;
  DateTime? _dueDate;
  bool _isSubmitting = false;
  List<GroupResponseModel> _groups = [];
  bool _loadingGroups = true;
  String? _errorGroups;

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
      if (userId == null) throw Exception('unidentified user');
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

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) throw Exception('unidentified user');
      final now = DateTime.now();
      final expense = {
        'name': _name,
        'amount': _amount,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'userId': int.parse(userId),
        'groupId': _selectedGroup!.id,
        'dueDate': _dueDate!.toIso8601String(),
      };
      await ExpensesService().createExpense(expense);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating spending: $e')),
      );
    }
  }

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
        title: const Text('Name'),
        content: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(labelText: 'Name Expense'),
          validator: (v) => (v == null || v.isEmpty) ? 'Ingrese un nombre' : null,
          onChanged: (v) => setState(() => _name = v),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Amount'),
        content: TextFormField(
          initialValue: _amount == 0.0 ? '' : _amount.toString(),
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Ingrese un monto';
            final value = double.tryParse(v);
            if (value == null || value <= 0) return 'Amount invalid';
            return null;
          },
          onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0.0),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Group'),
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
          onChanged: (g) => setState(() => _selectedGroup = g),
          decoration: const InputDecoration(labelText: 'Select a group'),
          validator: (v) => v == null ? 'Seleccione un grupo' : null,
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Due Date'),
        content: InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: _dueDate ?? now,
              firstDate: now,
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) setState(() => _dueDate = picked);
          },
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Due Date'),
            child: Text(
              _dueDate == null
                  ? 'Select a date'
                  : DateFormat('yyyy-MM-dd').format(_dueDate!),
            ),
          ),
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Summary'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NameExpense: $_name'),
            Text('Amount: \$${_amount.toStringAsFixed(2)}'),
            Text('Group: ${_selectedGroup?.name ?? ''}'),
            Text('DueDate: ${_dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : ''}'),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _name.isNotEmpty;
      case 1:
        return _amount > 0;
      case 2:
        return _selectedGroup != null;
      case 3:
        return _dueDate != null;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Expense')),
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
                // Forzar validación
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