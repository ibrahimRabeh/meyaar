import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meyar/util/BottomNav.dart';
import 'dart:convert';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/EmployeeApplication/QuizPage/Quizsumm.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _quizStarted = false;
  String _currentQuestion = '';
  List<String> _currentOptions = [];
  List<Map<String, dynamic>> _identifiedWeaknesses = [];
  List<Map<String, dynamic>> _identifiedStrengths = [];
  int _questionCount = 0;
  final int _maxQuestions = 6;
  Map<String, dynamic>? _employeeData;
  String _currentArea = ''; // Track which area is being tested

  // ChatGPT API configuration
  final String _apiKey = '';
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      final String responseString = await DefaultAssetBundle.of(context)
          .loadString('assets/employee.json');
      setState(() {
        _employeeData = jsonDecode(responseString);
      });
    } catch (e) {
      print('Error loading employee data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading employee data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _generatePromptBasedOnArea() {
    if (_employeeData == null) return '';

    final employeeInfo = _employeeData!['employeeData'];
    final random =
        DateTime.now().millisecondsSinceEpoch % 7; // Random area selection

    // Select testing area based on performance metrics and random factor
    final kpis = employeeInfo['kpi_objectives'] as List;
    final strengthsKpis = kpis.where((kpi) {
      final score = double.tryParse(
              kpi['employee_score'].toString().replaceAll('%', '')) ??
          0;
      return score >= 90;
    }).toList();
    final weakestKpis = kpis.where((kpi) {
      final score = double.tryParse(
              kpi['employee_score'].toString().replaceAll('%', '')) ??
          0;
      return score < 90;
    }).toList();

    Map<String, dynamic> selectedKpi;
    if (weakestKpis.isNotEmpty) {
      selectedKpi = weakestKpis[random % weakestKpis.length];
      _currentArea = selectedKpi['objective'];
    } else {
      selectedKpi = kpis[random % kpis.length];
      _currentArea = selectedKpi['objective'];
    }
    if (strengthsKpis.isNotEmpty) {
      selectedKpi = strengthsKpis[random % strengthsKpis.length];
      _currentArea = selectedKpi['objective'];
    } else {
      selectedKpi = kpis[random % kpis.length];
      _currentArea = selectedKpi['objective'];
    }

    return '''
    Based on this employee data:
    Job Title: ${employeeInfo['employee']['job_title']}
    Department: ${employeeInfo['employee']['department']}
    Testing Area: ${selectedKpi['objective']}
    Current Performance: ${selectedKpi['performance_summary']}
    Key Responsibilities: ${employeeInfo['job_description']['key_responsibilities'].join(', ')}

    Generate a challenging multiple choice question that tests knowledge and skills related to ${selectedKpi['objective']},
    considering that the employee's current performance in this area is: ${selectedKpi['performance_summary']}


    The question should follow these guidelines:
    1. The question should be specific and technical
    2. All answer options must be plausible and realistic
    3. Wrong answers should be common misconceptions or approaches that seem correct at first glance
    4. All options should be of similar length and detail
    5. Avoid obviously incorrect or silly answers
    6. Each wrong answer should be something that someone with partial knowledge might choose
    7. Use industry-standard terminology in all options

    Return the response in JSON format in the following structure it needs to be 100% the same format:
    {
      "question": "technical question related to the area",
      "options": [{
        "text": "the best practice or most accurate approach",
        "isCorrect": true,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }
      ],
      "area": "${selectedKpi['objective']}",
      "difficulty": "challenging",
      "explanation": "Brief explanation of why the correct answer is best and why the others fall short"
    }
    
    Example of good options:
    - For a data quality question:
      ✓ "Implement automated data validation with both syntax and semantic checks"
      ✓ "Validate data only after it's been transformed and loaded"
      ✓ "Rely on end-user reporting to identify data quality issues"
      ✓ "Perform manual spot checks on random data samples"

    Example of bad options (avoid these):
      "Don't check the data at all"
      "Delete all invalid data"
      "Ask someone else to do it"
      "Ignore data quality completely"
    ''';
  }

  Future<Map<String, dynamic>> _generateQuestion(
      {bool isCorrect = true}) async {
    if (_employeeData == null) {
      await _loadEmployeeData();
      if (_employeeData == null) {
        print('Error loading employee data');
        return _getFallbackQuestion();
      }
    }

    setState(() => _isLoading = true);

    try {
      final employeeInfo = _employeeData!['employeeData'];
      final kpiObjectives = employeeInfo['kpi_objectives'] as List;

      String prompt;
      if (!_quizStarted) {
        prompt = _generatePromptBasedOnArea();
      } else {
        // Find the current KPI objective safely
        Map<String, dynamic> currentKpi;
        try {
          currentKpi = kpiObjectives.firstWhere(
              (kpi) => kpi['objective'] == _currentArea,
              orElse: () => kpiObjectives.first);
        } catch (e) {
          currentKpi = kpiObjectives.first;
        }

        _currentArea = currentKpi?['objective'];

        prompt = '''
        Previous answer was ${isCorrect ? 'correct' : 'incorrect'} in the area of $_currentArea.
        ${isCorrect ? 'Test another aspect' : 'Dig deeper into this area'}.
        
        Employee Context:
        ${employeeInfo['job_description']['purpose']}
        
        Generate another relevant question, considering the performance summary: 
        ${currentKpi['performance_summary']}
        
    Generate a challenging multiple choice question that tests knowledge and skills related to ${currentKpi['objective']},
    considering that the employee's current performance in this area is: ${currentKpi['performance_summary']}


    The question should follow these guidelines:
    1. The question should be specific and technical
    2. All answer options must be plausible and realistic
    3. Wrong answers should be common misconceptions or approaches that seem correct at first glance
    4. All options should be of similar length and detail
    5. Avoid obviously incorrect or silly answers
    6. Each wrong answer should be something that someone with partial knowledge might choose
    7. Use industry-standard terminology in all options

    Return the response in JSON format in the following structure it needs to be 100% the same format:
    {
      "question": "technical question related to the area",
      "options": [{
        "text": "the best practice or most accurate approach",
        "isCorrect": true,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }, 
        {
        "text": "another plausible option",
        "isCorrect": false,
        }
      ],
      "area": "${currentKpi['objective']}",
      "difficulty": "challenging",
      "explanation": "Brief explanation of why the correct answer is best and why the others fall short"
    }
    
    Example of good options:
    - For a data quality question:
      ✓ "Implement automated data validation with both syntax and semantic checks"
      ✓ "Validate data only after it's been transformed and loaded"
      ✓ "Rely on end-user reporting to identify data quality issues"
      ✓ "Perform manual spot checks on random data samples"

    Example of bad options (avoid these):
      "Don't check the data at all"
      "Delete all invalid data"
      "Ask someone else to do it"
      "Ignore data quality completely"
    ''';
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String contentString = data['choices'][0]['message']['content'];
        print('Debug - API Response: $contentString'); // Add debug print

        try {
          final Map<String, dynamic> questionData = jsonDecode(contentString);
          return questionData;
        } catch (e) {
          print('Error parsing API response: $e');
          return _getFallbackQuestion();
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to generate question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating question: $e');
      return _getFallbackQuestion();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, dynamic> _getFallbackQuestion() {
    String area = 'Data Analysis';

    try {
      if (_employeeData != null) {
        final kpiObjectives =
            _employeeData!['employeeData']['kpi_objectives'] as List;
        if (kpiObjectives.isNotEmpty) {
          area = kpiObjectives[0]['objective'];
        }
      }
    } catch (e) {
      print('Error getting fallback area: $e');
    }

    // Set the current area for consistency
    _currentArea = area;

    // Return a relevant fallback question based on the job description
    return {
      'question':
          'What is the most effective approach to improve data quality in business intelligence?',
      'options': [
        {
          'text':
              'Implement automated validation with real-time monitoring and alerts',
          "isCorrect": true,
        },
        {
          'text': 'Wait for end-users to report data inconsistencies',
          "isCorrect": false,
        },
        {
          'text': 'Review data quality only during quarterly audits',
          "isCorrect": false,
        },
        {
          'text': 'Perform manual data validation on a random sample',
          "isCorrect": false,
        }
      ],
      'area': area,
      'explanation':
          'Automated validation with real-time monitoring provides immediate detection and resolution of data quality issues, ensuring continuous data integrity.'
    };
  }

  Future<void> _startQuiz() async {
    if (!mounted) return;

    try {
      setState(() => _quizStarted = true);
      final questionData = await _generateQuestion();

      if (!mounted) return;

      // Safely extract and validate the data
      final question = questionData['question'] ?? 'Error loading question';
      final options = (questionData['options'] as List?)
              ?.map((e) => e["text"].toString())
              .toList() ??
          ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
      final area = questionData['area']?.toString() ?? 'General Knowledge';

      setState(() {
        _currentQuestion = question;
        _currentOptions = options;
        _currentArea = area;
        _questionCount++;
      });
    } catch (e) {
      print('Error starting quiz: $e');
      if (mounted) {
        setState(() {
          _currentQuestion =
              'What is the most important aspect of data quality?';
          _currentOptions = [
            'Data validation and verification',
            'Regular data auditing',
            'Consistent data formatting',
            'Automated error checking'
          ];
          _currentArea = 'Data Quality';
          _questionCount++;
        });
      }
    }
  }

  // Replace your current _generateCourseRecommendations method with this:
  Future<RecommendationData> _generateCourseRecommendations() async {
    if (_employeeData == null ||
        _identifiedWeaknesses.isEmpty ||
        _identifiedStrengths.isEmpty) {
      return RecommendationData(
        weaknesses: _identifiedWeaknesses,
        strengths: _identifiedStrengths,
        recommendations: [],
      );
    }

    final prompt = '''
    Based on this employee's quiz performance, provide a detailed analysis.

    Quiz Performance Details:
    ${_identifiedWeaknesses.map((w) => '''
    Area: ${w['area']}
    Question: ${w['question']}
    Current Performance: ${w['current_performance']}
    ''').join('\n')}
    ${_identifiedStrengths.map((s) => '''
    Area: ${s['area']}
    Question: ${s['question']}
    Current Performance: ${s['current_performance']}
    ''').join('\n')}
    
    Employee Context:
    Job Title: ${_employeeData!['employeeData']['employee']['job_title']}
    Department: ${_employeeData!['employeeData']['employee']['department']}
    Overall Performance Rating: ${_employeeData!['employeeData']['overall_performance']['performance_rating']}
    
    Please provide a comprehensive analysis in the following JSON format:
    {
      "performance_analysis": {
        "strengths": [
          {
            "area": "name of the strong area",
            "details": "detailed explanation of strength",
            "impact": "how this strength benefits their role"
          }
        ],
        "weaknesses": [
          {
            "area": "name of the weak area",
            "details": "detailed explanation of weakness",
            "impact": "how this affects their performance",
            "improvement_needed": "specific improvements needed"
          }
        ],
        "knowledge_gaps": [
          {
            "area": "specific topic or skill",
            "description": "detailed description of the gap",
            "priority": "high/medium/low"
          }
        ]
      },
      "overall_assessment": {
        "summary": "comprehensive summary of performance",
        "key_findings": [
          "key finding 1",
          "key finding 2"
        ],
        "development_priorities": [
          "priority 1",
          "priority 2"
        ]
      },
      "recommendations": [
        {
          "area": "area name",
          "courses": [
            {
              "title": "course name",
              "description": "course description",
              "priority": "high/medium/low",
              "expected_outcome": "what they will learn"
            }
          ],
          "action_items": [
            "specific action 1",
            "specific action 2"
          ]
        }
      ],
      "skill_scores": {
        "area_name": {
          "score": "numerical score",
          "proficiency_level": "expert/advanced/intermediate/beginner",
          "trend": "improving/stable/needs attention"
        }
      }
    }
    ''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentString = data['choices'][0]['message']['content'];
        final analysisData = jsonDecode(contentString);

        // Create structured analysis data
        final completeAnalysis = {
          'performance_analysis': analysisData['performance_analysis'],
          'overall_assessment': analysisData['overall_assessment'],
          'skill_scores': analysisData['skill_scores'],
        };

        return RecommendationData(
          weaknesses: _identifiedWeaknesses,
          strengths: _identifiedStrengths,
          recommendations:
              List<Map<String, dynamic>>.from(analysisData['recommendations']),
          analysis: completeAnalysis,
        );
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return RecommendationData(
          weaknesses: _identifiedWeaknesses,
          strengths: _identifiedStrengths,
          recommendations: [],
          analysis: {},
        );
      }
    } catch (e) {
      print('Error generating recommendations: $e');
      return RecommendationData(
        weaknesses: _identifiedWeaknesses,
        strengths: _identifiedStrengths,
        recommendations: [],
        analysis: {},
      );
    }
  }

// Update _handleAnswer to use the new data
  // Replace your _handleAnswer method with this:
  Future<void> _handleAnswer(int selectedIndex) async {
    final isCorrect = selectedIndex == 0;

    if (!isCorrect && _employeeData != null) {
      final kpiObjectives =
          _employeeData!['employeeData']['kpi_objectives'] as List;
      final currentKpi = kpiObjectives.firstWhere(
        (kpi) => kpi['objective'].toString() == _currentArea,
        orElse: () => {'performance_summary': 'No performance data available'},
      );

      _identifiedWeaknesses.add({
        'area': _currentArea,
        'question': _currentQuestion,
        'selected_answer': _currentOptions[selectedIndex],
        'correct_answer': _currentOptions[0],
        'current_performance': currentKpi['performance_summary'],
      });
    } else {
      final kpiObjectives =
          _employeeData!['employeeData']['kpi_objectives'] as List;
      final currentKpi = kpiObjectives.firstWhere(
        (kpi) => kpi['objective'].toString() == _currentArea,
        orElse: () => {'performance_summary': 'No performance data available'},
      );
      _identifiedStrengths.add({
        'area': _currentArea,
        'question': _currentQuestion,
        'selected_answer': _currentOptions[selectedIndex],
        'correct_answer': _currentOptions[0],
        'current_performance': currentKpi['performance_summary'],
      });
    }

    if (_questionCount >= _maxQuestions - 1) {
      setState(() => _isLoading = true);

      try {
        final analysisData = await _generateCourseRecommendations();

        if (!mounted) return;

        setState(() => _isLoading = false);

        // Navigate to summary page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizSummaryPage(
              recommendations: analysisData.recommendations,
              analysis: analysisData.analysis,
              employeeInfo: _employeeData!['employeeData']['employee'],
              onViewCourses: () {
                Navigator.of(context).pushReplacementNamed(
                  '/Courses',
                  arguments: analysisData.recommendations,
                );
              },
            ),
          ),
        );
      } catch (e) {
        print('Error processing quiz results: $e');
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error processing quiz results. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      return;
    }

    // Show loading indicator for next question
    setState(() => _isLoading = true);

    try {
      final kpiObjectives =
          _employeeData!['employeeData']['kpi_objectives'] as List;
      final currentKpi = kpiObjectives.firstWhere(
        (kpi) => kpi['objective'].toString() == _currentArea,
        orElse: () => {'performance_summary': 'No performance data available'},
      );

      _identifiedStrengths.add({
        'area': _currentArea,
        'question': _currentQuestion,
        'selected_answer': _currentOptions[selectedIndex],
        'correct_answer': _currentOptions[0],
        'current_performance': currentKpi['performance_summary'],
      });
      // Generate next question if not at max questions
      final questionData = await _generateQuestion(isCorrect: isCorrect);

      if (!mounted) return;

      // Extract question data safely
      final question = questionData['question'];
      final options = questionData['options'] as List?;
      final area = questionData['area']?.toString();

      // Map options to list of strings
      final mappedOptions =
          options?.map((option) => option['text'].toString()).toList() ??
              [
                'Data validation and verification',
                'Regular data auditing',
                'Consistent data formatting',
                'Automated error checking'
              ];

      setState(() {
        _isLoading = false;
        _currentQuestion =
            question ?? 'What is the most important aspect of data quality?';
        _currentOptions = mappedOptions;
        _currentArea = area ?? 'Data Quality';
        _questionCount++;
      });
    } catch (e) {
      print('Error handling answer: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentQuestion =
              'What is the most important aspect of data quality?';
          _currentOptions = [
            'Data validation and verification',
            'Regular data auditing',
            'Consistent data formatting',
            'Automated error checking'
          ];
          _currentArea = 'Data Quality';
          _questionCount++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final mediaQuery = MediaQuery.of(context);
    final bottomNavHeight = !isDesktop ? kBottomNavigationBarHeight : 0.0;
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final appBarHeight = isDesktop ? 130.0 : 60.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: appBarHeight,
        leading: isDesktop
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        title: Text(
          'Skill Assessment',
          style: TextStyle(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 24 : 20,
          ),
        ),
      ),
      drawer: isDesktop ? ResponsiveNavBar(index: 3) : null,
      bottomNavigationBar: !isDesktop ? ResponsiveNavBar(index: 3) : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.05),
              AppColors.backgroundColor,
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight =
                constraints.maxHeight - bottomNavHeight - bottomPadding;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: availableHeight,
                  maxHeight: availableHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40.0 : 20.0,
                    vertical: 20.0,
                  ),
                  child: _isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.secondaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Generating question...',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : !_quizStarted
                          ? _buildStartScreen(isDesktop)
                          : _buildQuizContent(isDesktop, availableHeight),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStartScreen(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 40 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology,
            size: isDesktop ? 100 : 80,
            color: AppColors.secondaryColor,
          ),
          const SizedBox(height: 30),
          Text(
            'Ready to assess your skills?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'This assessment will analyze your performance\nand suggest targeted improvements.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 50 : 40,
                vertical: isDesktop ? 20 : 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Start Assessment',
                  style: TextStyle(
                    fontSize: isDesktop ? 20 : 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildFeatureList(),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      {'icon': Icons.timer, 'text': 'Adaptive questions'},
      {'icon': Icons.analytics, 'text': 'Detailed analysis'},
      {'icon': Icons.school, 'text': 'Personalized learning path'},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Display in a row for desktop
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: AppColors.secondaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feature['text']!.toString(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          // Display in a column for mobile
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: AppColors.secondaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feature['text']!.toString(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildQuizContent(bool isDesktop, double availableHeight) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 40 : 20),
        margin: EdgeInsets.only(bottom: isDesktop ? 0 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question $_questionCount of $_maxQuestions',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.category,
                              size: 16,
                              color: AppColors.secondaryColor,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                _currentArea,
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer,
                    color: AppColors.primaryColor,
                    size: isDesktop ? 24 : 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _currentQuestion,
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            SizedBox(height: isDesktop ? 30 : 20),
            ..._buildAnswerOptions(isDesktop),
            SizedBox(height: isDesktop ? 20 : 10),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _questionCount / _maxQuestions,
            backgroundColor: AppColors.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(_questionCount / _maxQuestions * 100).round()}% Complete',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnswerOptions(bool isDesktop) {
    return _currentOptions.asMap().entries.map((entry) {
      final optionLetter = String.fromCharCode(65 + entry.key); // A, B, C, D...

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleAnswer(entry.key),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.dividerColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        optionLetter,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: isDesktop ? 18 : 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class RecommendationData {
  final List<Map<String, dynamic>> weaknesses;
  final List<Map<String, dynamic>> recommendations;
  final Map<String, dynamic> analysis;
  final List<Map<String, dynamic>> strengths;

  RecommendationData({
    required this.weaknesses,
    required this.recommendations,
    this.analysis = const {},
    required this.strengths,
  });
}
