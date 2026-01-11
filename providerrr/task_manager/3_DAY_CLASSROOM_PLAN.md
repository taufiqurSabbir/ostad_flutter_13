# 🎓 3-Day Intensive Provider State Management Course

## ⏰ Course Overview
- **Duration**: 3 days × 1.5 hours = 4.5 hours total
- **Format**: Fast-paced, hands-on coding
- **Goal**: Master Provider basics and complete working app

---

## 📅 Day 1: Provider Fundamentals (1.5 hours)

### ⏱️ Session 1.1: Quick Theory (15 minutes)

#### Topics to Cover:
1. **What is State Management?** (3 min)
   - setState problems in large apps
   - Why Provider?
   - Provider vs other solutions

2. **Provider Core Concepts** (7 min)
   - `ChangeNotifier` - Base class
   - `notifyListeners()` - Triggers UI rebuild
   - `Consumer` - Listens to changes
   - `Provider.of()` - Access provider
   - `MultiProvider` - Multiple providers

3. **When to Use What?** (5 min)
   ```dart
   // Use Consumer for UI that rebuilds
   Consumer<MyProvider>(builder: (context, provider, child) => ...)
   
   // Use Provider.of with listen: false for actions
   Provider.of<MyProvider>(context, listen: false).doSomething()
   ```

#### Teaching Tip:
- Use whiteboard for quick diagram
- Show setState vs Provider comparison
- Keep it brief - students learn by doing!

---

### ⏱️ Session 1.2: Counter App - Live Coding (20 minutes)

#### Create Simple Counter Together:

**Step 1: Setup (5 min)**
```dart
// Add to pubspec.yaml
dependencies:
  provider: ^6.1.2

// Run: flutter pub get
```

**Step 2: Create Provider (7 min)**
```dart
// lib/providers/counter_provider.dart
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners(); // 🔥 Key point!
  }
  
  void decrement() {
    _counter--;
    notifyListeners();
  }
}
```

**Step 3: Setup in main.dart (8 min)**
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, provider, child) {
            return Text('${provider.counter}', style: TextStyle(fontSize: 48));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CounterProvider>(context, listen: false).increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### 🎯 Key Points to Emphasize:
- ✅ `notifyListeners()` is MANDATORY after state change
- ✅ `Consumer` rebuilds automatically
- ✅ `listen: false` in callbacks/actions
- ✅ Never use setState with Provider

---

### ⏱️ Session 1.3: Task Manager Setup (25 minutes)

#### Open Task Manager Project:

**Step 1: Project Overview (5 min)**
- Show folder structure
- Explain separation: providers, data, ui
- Show MultiProvider in main.dart

**Step 2: Study AuthProvider (10 min)**

Walk through `lib/providers/auth_provider.dart`:
```dart
class AuthProvider extends ChangeNotifier {
  // Private state
  String? _accessToken;
  UserModel? _userModel;
  
  // Public getters
  String? get accessToken => _accessToken;
  bool get isLoggedIn => _accessToken != null;
  
  // Save user data
  Future<void> saveUserData(UserModel model, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    
    _accessToken = token;
    _userModel = model;
    notifyListeners(); // UI updates automatically
  }
  
  // Logout
  Future<void> logout() async {
    _accessToken = null;
    _userModel = null;
    notifyListeners();
  }
}
```

**Key Discussion Points:**
- Private fields (`_variable`)
- Public getters
- Async operations
- SharedPreferences integration

**Step 3: Study Enums (5 min)**

Show `lib/core/enums/api_state.dart`:
```dart
enum ApiState {
  initial,   // Not started
  loading,   // In progress
  success,   // Completed
  error,     // Failed
}
```

**Why Enums?**
- Type safety
- No typos
- Better autocomplete
- Clear state tracking

**Step 4: Quick Q&A (5 min)**
- Answer student questions
- Clarify concepts
- Prepare for Day 2

---

### 📝 Day 1 Homework (Optional):
Create a simple Todo app with Provider:
- Add todo
- Delete todo
- Show count

---

## 📅 Day 2: Authentication Implementation (1.5 hours)

### ⏱️ Session 2.1: MultiProvider Setup (15 minutes)

#### Review main.dart Setup:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: TaskManagerApp(),
    ),
  );
}
```

**Discuss:**
- Why multiple providers?
- Each provider has single responsibility
- Providers can be accessed anywhere below

---

### ⏱️ Session 2.2: Login Screen Implementation (45 minutes)

#### Live Code Login Screen Together:

**Step 1: Form Setup (10 min)**
```dart
class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Loading Button with Consumer (15 min)**
```dart
Widget _buildSignInButton() {
  return Consumer<NetworkProvider>(
    builder: (context, networkProvider, child) {
      final isLoading = networkProvider.loginState == ApiState.loading;
      
      return FilledButton(
        onPressed: isLoading ? null : _onTapSignIn,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Icon(Icons.arrow_circle_right_outlined),
      );
    },
  );
}
```

**🔥 Key Teaching Points:**
- Consumer rebuilds only this button
- Button disabled during loading
- Loading indicator shown automatically

**Step 3: Handle Login Action (20 min)**
```dart
Future<void> _onTapSignIn() async {
  // Validate first
  if (!_formKey.currentState!.validate()) return;
  
  // Get providers (listen: false for actions!)
  final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  
  // Call login
  final result = await networkProvider.login(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );
  
  // Check if widget still mounted
  if (!mounted) return;
  
  // Handle result
  if (result != null) {
    // Save user data
    await authProvider.saveUserData(result['user'], result['token']);
    
    // Update API token
    ApiCaller.accessToken = result['token'];
    
    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login successful!')),
    );
    
    // Navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainNavBarHolderScreen()),
    );
  } else {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(networkProvider.errorMessage ?? 'Login failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**🎯 Critical Points to Highlight:**
1. **Validate before API call**
2. **listen: false for actions** (very important!)
3. **mounted check** after async
4. **Two providers working together** (Network + Auth)
5. **Error handling** with user feedback

---

### ⏱️ Session 2.3: Test & Debug (20 minutes)

#### Run the App Together:

1. **Start app** (2 min)
   ```bash
   flutter run
   ```

2. **Test login flow** (8 min)
   - Test with valid credentials
   - Test with invalid credentials
   - Show loading state
   - Show error messages

3. **Common Issues & Fixes** (10 min)

   **Issue 1: UI not updating**
   ```dart
   // ❌ Wrong
   void increment() {
     _counter++;
     // Forgot notifyListeners()!
   }
   
   // ✅ Correct
   void increment() {
     _counter++;
     notifyListeners();
   }
   ```

   **Issue 2: Too many rebuilds**
   ```dart
   // ❌ Wrong - rebuilds widget
   onPressed: () {
     Provider.of<MyProvider>(context).doSomething();
   }
   
   // ✅ Correct
   onPressed: () {
     Provider.of<MyProvider>(context, listen: false).doSomething();
   }
   ```

   **Issue 3: Provider not found**
   - Check MultiProvider in main.dart
   - Ensure widget is below MultiProvider in tree

---

### 📝 Day 2 Homework:
Implement Sign Up screen using Provider:
- Use NetworkProvider
- Add loading states
- Handle errors
- Navigate after success

---

## 📅 Day 3: Task Management & Practice (1.5 hours)

### ⏱️ Session 3.1: TaskProvider Deep Dive (20 minutes)

#### Study TaskProvider Together:

**Show Multiple Lists Management:**
```dart
class TaskProvider extends ChangeNotifier {
  List<TaskModel> _newTasks = [];
  List<TaskModel> _progressTasks = [];
  List<TaskModel> _completedTasks = [];
  
  ApiState _taskListState = ApiState.initial;
  String? _errorMessage;
  
  List<TaskModel> get newTasks => _newTasks;
  ApiState get taskListState => _taskListState;
  
  Future<void> fetchTasksByStatus(TaskStatus status) async {
    _taskListState = ApiState.loading;
    notifyListeners(); // Show loading
    
    try {
      final response = await ApiCaller.getRequest(url: url);
      
      if (response.isSuccess) {
        _newTasks = /* parse tasks */;
        _taskListState = ApiState.success;
      } else {
        _taskListState = ApiState.error;
        _errorMessage = response.errorMessage;
      }
    } catch (e) {
      _taskListState = ApiState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners(); // Update UI
  }
}
```

**🎯 Key Points:**
- Multiple lists for different statuses
- Separate state for each operation
- Try-catch for error handling
- notifyListeners() at start and end

---

### ⏱️ Session 3.2: Task List Screen (30 minutes)

#### Build Task Screen Together:

**Step 1: Initial Data Load (10 min)**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadData();
  });
}

Future<void> _loadData() async {
  final taskProvider = Provider.of<TaskProvider>(context, listen: false);
  await Future.wait([
    taskProvider.fetchTaskStatusCounts(),
    taskProvider.fetchTasksByStatus(TaskStatus.newTask),
  ]);
}
```

**Why addPostFrameCallback?**
- Can't call Provider in initState directly
- Need context after first frame
- Safe way to load initial data

**Step 2: Build UI with States (20 min)**
```dart
Widget _buildTaskList() {
  return Consumer<TaskProvider>(
    builder: (context, taskProvider, child) {
      // Loading
      if (taskProvider.taskListState == ApiState.loading) {
        return Center(child: CircularProgressIndicator());
      }
      
      // Error
      if (taskProvider.taskListState == ApiState.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(taskProvider.errorMessage ?? 'Error loading tasks'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }
      
      // Empty
      if (taskProvider.newTasks.isEmpty) {
        return Center(child: Text('No tasks yet!'));
      }
      
      // Success - Show list
      return RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          itemCount: taskProvider.newTasks.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: taskProvider.newTasks[index],
              refreshParent: _loadData,
            );
          },
        ),
      );
    },
  );
}
```

**🔥 Teaching Points:**
- Handle ALL states (loading, error, empty, success)
- User-friendly error messages
- Retry button for errors
- RefreshIndicator for pull-to-refresh

---

### ⏱️ Session 3.3: Add Task Screen (25 minutes)

#### Create Task Form Together:

**Step 1: Form with Provider (15 min)**
```dart
Widget _buildSubmitButton() {
  return Consumer<TaskProvider>(
    builder: (context, taskProvider, child) {
      final isLoading = taskProvider.createTaskState == ApiState.loading;
      
      return FilledButton(
        onPressed: isLoading ? null : _onTapSubmit,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.arrow_circle_right_outlined),
      );
    },
  );
}

Future<void> _onTapSubmit() async {
  if (!_formKey.currentState!.validate()) return;
  
  final taskProvider = Provider.of<TaskProvider>(context, listen: false);
  
  final success = await taskProvider.createTask(
    title: _titleController.text.trim(),
    description: _descriptionController.text.trim(),
  );
  
  if (!mounted) return;
  
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task created!')),
    );
    Navigator.pop(context, true); // Return true to trigger refresh
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(taskProvider.errorMessage ?? 'Failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**Step 2: Refresh Parent After Add (10 min)**
```dart
// In parent screen
Future<void> _onTapAddButton() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AddNewTaskScreen()),
  );
  
  // If task was created, refresh list
  if (result == true) {
    _loadData();
  }
}
```

---

### ⏱️ Session 3.4: Practice & Wrap Up (15 minutes)

#### Quick Practice Exercise (10 min):

**Student Task:**
Implement delete task functionality:

```dart
// In TaskProvider
Future<bool> deleteTask(String taskId) async {
  _deleteTaskState = ApiState.loading;
  notifyListeners();
  
  try {
    final response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(taskId),
    );
    
    if (response.isSuccess) {
      _deleteTaskState = ApiState.success;
      notifyListeners();
      return true;
    } else {
      _deleteTaskState = ApiState.error;
      _errorMessage = response.errorMessage;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _deleteTaskState = ApiState.error;
    _errorMessage = e.toString();
    notifyListeners();
    return false;
  }
}

// In UI
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final success = await taskProvider.deleteTask(task.id);
    if (success) {
      // Refresh list
      refreshParent();
    }
  },
)
```

#### Final Q&A & Summary (5 min):

**What We Learned:**
✅ Provider setup with MultiProvider
✅ ChangeNotifier and notifyListeners()
✅ Consumer vs Provider.of()
✅ listen: false for actions
✅ Async operations with Provider
✅ Loading, error, and success states
✅ Form handling with Provider
✅ Multiple providers working together

**Best Practices Checklist:**
- [ ] Always call notifyListeners() after state change
- [ ] Use listen: false in callbacks/actions
- [ ] Check mounted after async operations
- [ ] Handle all states (loading, error, success)
- [ ] Validate forms before API calls
- [ ] Show user feedback (SnackBar)
- [ ] Use enums for type safety

---

## 📝 Final Assignment

**Build a Complete Screen:**

Choose one to implement with Provider:
1. **Progress Tasks Screen** - Similar to NewTaskScreen
2. **Completed Tasks Screen** - Similar to NewTaskScreen
3. **Update Profile Screen** - Form with NetworkProvider

**Requirements:**
- Use appropriate Provider
- Handle loading states
- Show errors properly
- Add pull-to-refresh
- Validate inputs
- Show success messages

**Due:** Next class session

---

## 🎯 Quick Reference for Students

### Provider Checklist:

**Creating Provider:**
```dart
class MyProvider extends ChangeNotifier {
  // State
  int _value = 0;
  
  // Getter
  int get value => _value;
  
  // Method
  void update() {
    _value++;
    notifyListeners(); // ⚠️ REQUIRED!
  }
}
```

**Using in UI:**
```dart
// For UI that rebuilds
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text('${provider.value}');
  },
)

// For actions
onPressed: () {
  Provider.of<MyProvider>(context, listen: false).update();
}
```

**Common Mistakes:**
❌ Forgot notifyListeners()
❌ Used listen: true in callback
❌ Didn't check mounted after async
❌ Mixed setState with Provider

---

## 📚 Additional Resources

**Must Read:**
- [PROVIDER_QUICK_REFERENCE.md](PROVIDER_QUICK_REFERENCE.md) - Cheat sheet
- [PROVIDER_TEACHING_GUIDE.md](PROVIDER_TEACHING_GUIDE.md) - Detailed guide

**Practice Projects:**
1. Counter app
2. Todo app  
3. Weather app
4. Complete this Task Manager

---

## 💡 Teaching Tips

### Time Management:
- **Stick to schedule** - Don't go over time
- **Skip if stuck** - Move on, come back later
- **Live code** - Students follow along
- **Quick questions** - Answer briefly

### Engagement:
- **Ask questions** - "Why do we use listen: false?"
- **Show mistakes** - Deliberately forget notifyListeners()
- **Pair students** - Help each other
- **Celebrate wins** - Clap when app works!

### Troubleshooting:
- **Screen share** - Show student's code
- **Quick fix** - Don't spend too long
- **Note for later** - Address complex issues after class
- **Use documentation** - Show them how to find answers

---

## ✅ Success Criteria

By end of Day 3, students should:
- [ ] Understand Provider concept
- [ ] Create basic ChangeNotifier
- [ ] Use Consumer correctly
- [ ] Know when to use listen: false
- [ ] Handle async operations
- [ ] Implement loading states
- [ ] Build at least one complete screen
- [ ] Debug common Provider issues

---

## 🚀 After Course

**Next Steps:**
1. Complete remaining screens
2. Build personal project
3. Join Flutter community
4. Share your work

**Resources:**
- Flutter documentation
- Provider documentation  
- This project code
- YouTube tutorials

---

**Good Luck! You've got this! 🎉**

*Remember: Provider is just a tool. Understanding state management concepts is what matters most.*

---

**Course Summary:**
- **Day 1**: Fundamentals + AuthProvider
- **Day 2**: Login Implementation
- **Day 3**: Task Management + Practice

**Total**: 4.5 hours of intensive, hands-on learning! 💪
