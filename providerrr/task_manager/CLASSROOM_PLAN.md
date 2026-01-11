# 👨‍🏫 Classroom Teaching Plan - Provider State Management

## 📅 Course Structure (5 Days / 10 Hours Total)

This plan is designed for teaching Provider state management step-by-step in a classroom environment.

---

## Day 1: Introduction & Setup (2 hours)

### Session 1.1: Theory & Concepts (45 min)

#### Topics to Cover:
1. **What is State Management?** (10 min)
   - App state vs Local state
   - Why we need state management
   - Common problems without state management

2. **Introduction to Provider** (15 min)
   - What is Provider?
   - Benefits over setState
   - When to use Provider
   - Provider vs other solutions (GetX, Bloc, Riverpod)

3. **Core Concepts** (20 min)
   - `ChangeNotifier`
   - `notifyListeners()`
   - `Consumer` widget
   - `Provider.of()`
   - `MultiProvider`

#### Teaching Approach:
- Use diagrams on whiteboard
- Show real-world analogies
- Compare with setState approach

---

### Session 1.2: Hands-On Setup (45 min)

#### Practical Tasks:

**Task 1: Create New Flutter Project** (10 min)
```bash
flutter create provider_demo
cd provider_demo
```

**Task 2: Add Provider Dependency** (5 min)
```yaml
dependencies:
  provider: ^6.1.2
```

**Task 3: Create First Provider** (30 min)

Create `lib/providers/counter_provider.dart`:
```dart
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners();
  }
  
  void decrement() {
    _counter--;
    notifyListeners();
  }
  
  void reset() {
    _counter = 0;
    notifyListeners();
  }
}
```

#### Student Activity:
- Students code along
- Explain each line as you type
- Answer questions immediately

---

### Session 1.3: Using Provider in UI (30 min)

**Update main.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/counter_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter with Provider')),
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, provider, child) {
            return Text(
              '${provider.counter}',
              style: TextStyle(fontSize: 48),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Provider.of<CounterProvider>(context, listen: false).increment();
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              Provider.of<CounterProvider>(context, listen: false).decrement();
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

#### Teaching Points:
- Explain `ChangeNotifierProvider`
- Show `Consumer` widget
- Demonstrate `listen: false`
- Run the app together

---

## Day 2: Building Todo List App (2 hours)

### Session 2.1: Project Setup (20 min)

#### Create Project Structure:
```
lib/
├── models/
│   └── todo_model.dart
├── providers/
│   └── todo_provider.dart
├── screens/
│   └── todo_screen.dart
└── main.dart
```

#### Task 1: Create Todo Model (10 min)
```dart
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}
```

---

### Session 2.2: Create Todo Provider (40 min)

#### Task 2: Implement TodoProvider
```dart
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  
  List<Todo> get todos => _todos;
  
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((t) => t.isCompleted).length;
  int get pendingTodos => _todos.where((t) => !t.isCompleted).length;
  
  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
    notifyListeners();
  }
  
  void toggleTodo(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }
  
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
```

#### Teaching Points:
- Multiple getters for computed values
- List manipulation
- Finding items in list
- When to call notifyListeners()

---

### Session 2.3: Build UI (60 min)

#### Create Todo Screen with:
- ListView for todos
- Add todo functionality
- Toggle completion
- Delete todos
- Show counts

#### Students Practice:
- Build the UI themselves
- Use Consumer for displaying list
- Use Provider.of for actions
- Test the app

---

## Day 3: Authentication with Provider (2 hours)

### Session 3.1: Auth Provider (60 min)

#### Topics:
1. **SharedPreferences Integration** (20 min)
   - Saving user data
   - Loading user data
   - Clearing data

2. **Auth State Management** (40 min)
   - Login state
   - User model
   - Token management

#### Code Together:
```dart
class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;
  bool _isLoading = false;
  
  bool get isAuthenticated => _token != null;
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      _token = 'fake_token';
      _user = User(email: email, name: 'User');
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}
```

---

### Session 3.2: Login Screen (60 min)

#### Build Login Screen Together:
- Email/password form
- Loading indicator during login
- Error handling
- Navigation after success

#### Key Learning:
- Form validation
- Async operations with Provider
- Checking mounted state
- Navigation with Provider

---

## Day 4: API Integration (2 hours)

### Session 4.1: HTTP Requests with Provider (60 min)

#### Topics:
1. **HTTP Package Setup** (10 min)
2. **API Service Layer** (20 min)
3. **Provider with API Calls** (30 min)

#### Create API Provider:
```dart
class ApiProvider extends ChangeNotifier {
  List<Post> _posts = [];
  ApiState _state = ApiState.initial;
  String? _error;
  
  List<Post> get posts => _posts;
  ApiState get state => _state;
  String? get error => _error;
  
  Future<void> fetchPosts() async {
    _state = ApiState.loading;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _posts = data.map((json) => Post.fromJson(json)).toList();
        _state = ApiState.success;
      } else {
        _state = ApiState.error;
        _error = 'Failed to load posts';
      }
    } catch (e) {
      _state = ApiState.error;
      _error = e.toString();
    }
    
    notifyListeners();
  }
}
```

---

### Session 4.2: Display API Data (60 min)

#### Build Screen with:
- Loading indicator
- Error message
- Post list
- Pull to refresh

#### Students Activity:
- Implement the screen
- Handle all states
- Add pull to refresh
- Test with real API

---

## Day 5: Task Manager App (2 hours)

### Session 5.1: Project Overview (30 min)

#### Review Complete Project Structure:
```
lib/
├── core/
│   ├── constants/
│   └── enums/
├── data/
│   ├── models/
│   ├── services/
│   └── utils/
├── providers/
│   ├── auth_provider.dart
│   ├── task_provider.dart
│   └── network_provider.dart
└── ui/
    ├── screens/
    └── widgets/
```

#### Discuss:
- Clean architecture
- Separation of concerns
- Naming conventions
- File organization

---

### Session 5.2: Code Walkthrough (60 min)

#### Go Through Key Files:
1. **AuthProvider** (15 min)
   - User management
   - Token handling
   - Persistence

2. **TaskProvider** (15 min)
   - CRUD operations
   - Multiple lists
   - State management

3. **NetworkProvider** (15 min)
   - API calls
   - Error handling
   - Response parsing

4. **Screens** (15 min)
   - Login screen
   - Task list screen
   - Add task screen

---

### Session 5.3: Best Practices & Q&A (30 min)

#### Discuss:
- Common mistakes and how to avoid them
- Performance optimization
- Testing strategies
- Production considerations

#### Q&A Session:
- Answer student questions
- Debug common issues
- Share resources

---

## 📝 Daily Homework

### Day 1 Homework:
Create a temperature converter app with Provider
- Celsius to Fahrenheit
- Fahrenheit to Celsius
- Use Provider for state

### Day 2 Homework:
Add these features to Todo app:
- Edit todo
- Filter by status
- Search functionality

### Day 3 Homework:
Add these to Auth app:
- Remember me checkbox
- Auto-logout after timeout
- Profile screen

### Day 4 Homework:
Create a weather app:
- Fetch weather from API
- Show loading/error states
- Cache last result

### Day 5 Homework:
Enhance Task Manager:
- Add categories
- Add due dates
- Add priority levels

---

## 🎯 Assessment Plan

### Day 3 Quiz (30 min):
- Multiple choice questions
- Code reading questions
- Debugging scenarios

### Final Project (Due Day 7):
Build a complete app with:
- Authentication
- API integration
- CRUD operations
- Professional UI
- Error handling

### Evaluation Criteria:
- Code quality: 30%
- Functionality: 30%
- UI/UX: 20%
- Error handling: 10%
- Documentation: 10%

---

## 📚 Teaching Resources

### Visual Aids:
- Provider architecture diagram
- State flow diagram
- Widget tree visualization

### Code Samples:
- Counter app
- Todo app
- Login flow
- API integration

### References:
- Official Provider documentation
- Flutter documentation
- This project source code

---

## 💡 Teaching Tips

### For Success:
1. **Live Code**: Always code live, don't use slides for code
2. **Encourage Questions**: Pause frequently for questions
3. **Repeat Key Concepts**: Repetition helps retention
4. **Show Mistakes**: Demonstrate common errors
5. **Debug Together**: Show debugging process
6. **Use Analogies**: Real-world comparisons help
7. **Check Understanding**: Ask students to explain concepts
8. **Pair Programming**: Have students work in pairs

### Common Student Challenges:
1. Forgetting `notifyListeners()`
   - Solution: Add print statement in `notifyListeners()`
   
2. Using `listen: true` in callbacks
   - Solution: Show performance issues it causes
   
3. Provider not found error
   - Solution: Draw widget tree on board
   
4. Confusion between Consumer and Provider.of
   - Solution: Create decision flowchart

---

## 🎓 Success Metrics

Students should be able to:
- [ ] Explain Provider concept
- [ ] Create ChangeNotifier classes
- [ ] Use Consumer widget
- [ ] Use Provider.of correctly
- [ ] Handle async operations
- [ ] Manage multiple providers
- [ ] Debug Provider issues
- [ ] Build complete app with Provider

---

## 📞 Support After Class

- Create WhatsApp/Discord group
- Office hours: 2 hours per week
- Code review sessions
- Share additional resources

---

**Good Luck Teaching! 🚀**

*Remember: Patience and practice are key to mastering Provider!*
