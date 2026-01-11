# 🎯 Provider State Management - Quick Reference Guide

## 📋 Cheat Sheet for Students

### 1️⃣ Setup Provider (main.dart)

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

---

### 2️⃣ Create a Provider

```dart
import 'package:flutter/foundation.dart';

class MyProvider extends ChangeNotifier {
  // Private state
  int _counter = 0;
  bool _isLoading = false;
  
  // Public getters
  int get counter => _counter;
  bool get isLoading => _isLoading;
  
  // Methods that change state
  void increment() {
    _counter++;
    notifyListeners(); // ⚠️ IMPORTANT: Always call after state changes!
  }
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    
    _isLoading = false;
    notifyListeners();
  }
}
```

**Key Points:**
- Extend `ChangeNotifier`
- Private fields (`_variable`)
- Public getters
- Call `notifyListeners()` after state changes

---

### 3️⃣ Access Provider in UI (Two Ways)

#### A. Consumer (for widgets that need to rebuild)

```dart
Consumer<MyProvider>(
  builder: (context, provider, child) {
    // This rebuilds when provider.notifyListeners() is called
    return Text('Counter: ${provider.counter}');
  },
)
```

**Use when:** You need the widget to rebuild when state changes.

#### B. Provider.of (for actions, listen: false)

```dart
void _handleButtonPress() {
  final provider = Provider.of<MyProvider>(context, listen: false);
  provider.increment(); // Won't rebuild this widget
}
```

**Use when:** You just want to call a method, not rebuild the widget.

---

### 4️⃣ Common Patterns

#### ✅ Loading Button Pattern

```dart
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return ElevatedButton(
      onPressed: provider.isLoading ? null : () {
        provider.doSomething();
      },
      child: provider.isLoading 
        ? CircularProgressIndicator() 
        : Text('Submit'),
    );
  },
)
```

#### ✅ List with States Pattern

```dart
Consumer<TaskProvider>(
  builder: (context, taskProvider, child) {
    // Loading state
    if (taskProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Error state
    if (taskProvider.hasError) {
      return Center(child: Text('Error: ${taskProvider.errorMessage}'));
    }
    
    // Empty state
    if (taskProvider.items.isEmpty) {
      return Center(child: Text('No items'));
    }
    
    // Success state - show list
    return ListView.builder(
      itemCount: taskProvider.items.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(taskProvider.items[index]));
      },
    );
  },
)
```

#### ✅ Initial Data Load Pattern

```dart
@override
void initState() {
  super.initState();
  // Load data after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    provider.loadInitialData();
  });
}
```

#### ✅ Form Submission Pattern

```dart
Future<void> _submitForm() async {
  // Validate form first
  if (!_formKey.currentState!.validate()) return;
  
  // Get provider
  final provider = Provider.of<MyProvider>(context, listen: false);
  
  // Call async method
  final success = await provider.submitData(
    title: _titleController.text,
    description: _descriptionController.text,
  );
  
  // Check if widget is still mounted
  if (!mounted) return;
  
  // Handle result
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Success!')),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${provider.errorMessage}')),
    );
  }
}
```

---

### 5️⃣ Enums for States

```dart
enum ApiState {
  initial,   // Not started yet
  loading,   // API call in progress
  success,   // API call succeeded
  error,     // API call failed
}

// In your provider:
class MyProvider extends ChangeNotifier {
  ApiState _state = ApiState.initial;
  ApiState get state => _state;
  
  Future<void> fetchData() async {
    _state = ApiState.loading;
    notifyListeners();
    
    try {
      // API call here
      _state = ApiState.success;
    } catch (e) {
      _state = ApiState.error;
    }
    
    notifyListeners();
  }
}
```

---

### 6️⃣ Common Mistakes ❌

#### ❌ Mistake 1: Forgetting notifyListeners()
```dart
// WRONG
void increment() {
  _counter++;
  // UI won't update! ❌
}

// CORRECT
void increment() {
  _counter++;
  notifyListeners(); // ✅
}
```

#### ❌ Mistake 2: Using listen: true in actions
```dart
// WRONG - This will rebuild unnecessarily
void _handlePress() {
  final provider = Provider.of<MyProvider>(context); // ❌ listen: true by default
  provider.increment();
}

// CORRECT
void _handlePress() {
  final provider = Provider.of<MyProvider>(context, listen: false); // ✅
  provider.increment();
}
```

#### ❌ Mistake 3: Not checking mounted after async
```dart
// WRONG
Future<void> _loadData() async {
  await provider.fetchData();
  Navigator.pop(context); // ❌ Might crash if widget disposed
}

// CORRECT
Future<void> _loadData() async {
  await provider.fetchData();
  if (!mounted) return; // ✅ Check first
  Navigator.pop(context);
}
```

#### ❌ Mistake 4: Using setState with Provider
```dart
// WRONG - Don't mix setState with Provider
setState(() {
  // Updating provider state here ❌
});

// CORRECT - Let Provider handle it
provider.updateState(); // Provider calls notifyListeners() ✅
```

---

### 7️⃣ Quick Tips 💡

1. **Always use `listen: false` in callbacks/methods**
   ```dart
   onPressed: () {
     Provider.of<MyProvider>(context, listen: false).doSomething();
   }
   ```

2. **Use `Consumer` only where needed**
   ```dart
   // Only wrap the specific widget that needs to rebuild
   Column(
     children: [
       Text('Static text'), // This won't rebuild
       Consumer<MyProvider>(
         builder: (context, provider, child) {
           return Text('${provider.counter}'); // Only this rebuilds
         },
       ),
     ],
   )
   ```

3. **Check `mounted` after async operations**
   ```dart
   await someAsyncOperation();
   if (!mounted) return;
   // Now safe to use context
   ```

4. **Dispose resources in provider**
   ```dart
   class MyProvider extends ChangeNotifier {
     final TextEditingController _controller = TextEditingController();
     
     @override
     void dispose() {
       _controller.dispose();
       super.dispose();
     }
   }
   ```

---

### 8️⃣ Debugging Tips 🐛

1. **Provider not found error?**
   - Check widget tree: Is your widget below `MultiProvider`?
   - Check provider is added to `providers` list

2. **UI not updating?**
   - Did you call `notifyListeners()`?
   - Are you using `Consumer` or `Provider.of` without `listen: false`?

3. **Too many rebuilds?**
   - Are you using `listen: true` in a method/callback?
   - Use `listen: false` for actions

4. **State lost when navigating?**
   - Providers should be above `MaterialApp` in widget tree
   - Don't create providers inside screens

---

### 9️⃣ Practice Exercises

1. **Easy**: Create a counter app with Provider
2. **Medium**: Create a todo list with add/remove functionality
3. **Hard**: Implement login with API calls and loading states
4. **Expert**: Build the Task Manager app from scratch

---

### 🔟 Remember

✅ **DO:**
- Use `Consumer` for UI that needs to rebuild
- Use `Provider.of(context, listen: false)` for actions
- Call `notifyListeners()` after state changes
- Check `mounted` after async operations
- Use enums for states
- Handle errors gracefully

❌ **DON'T:**
- Forget to call `notifyListeners()`
- Use `setState` with Provider
- Use `listen: true` in callbacks
- Put providers inside screens
- Ignore error handling

---

## 📚 Quick Reference Table

| Scenario | Code |
|----------|------|
| Setup Provider | `MultiProvider(providers: [...])` |
| Create Provider | `class MyProvider extends ChangeNotifier` |
| Update State | `notifyListeners()` |
| Access for UI | `Consumer<MyProvider>(builder: ...)` |
| Access for Action | `Provider.of<MyProvider>(context, listen: false)` |
| Loading State | `if (provider.isLoading) return CircularProgressIndicator()` |
| Error State | `if (provider.hasError) return Text(provider.errorMessage)` |

---

**Happy Coding! 🚀**

*Keep this guide handy while working with Provider!*
