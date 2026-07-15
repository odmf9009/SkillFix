# Graph Report - .  (2026-07-11)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1157 nodes · 1674 edges · 52 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `969c1af8`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46
- Community 47
- Community 48
- Community 49
- Community 50
- Community 51

## God Nodes (most connected - your core abstractions)
1. `RepairHistoryService` - 28 edges
2. `LanguageService` - 22 edges
3. `ShoppingListService` - 16 edges
4. `MaintenanceService` - 10 edges
5. `AppLocalizations` - 7 edges
6. `Trade` - 7 edges
7. `TutorialVideo` - 6 edges
8. `_ProblemDetailScreenState` - 6 edges
9. `DiagnosticFlow` - 5 edges
10. `_AddEditReminderScreenState` - 5 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `RepairHistoryService`  [EXTRACTED]
  lib/screens/emergency_detail_screen.dart → lib/services/repair_history_service.dart
- `AppLocalizationsEn` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_en.dart → lib/l10n/app_localizations.dart
- `AppLocalizationsEs` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_es.dart → lib/l10n/app_localizations.dart
- `build` --references--> `LanguageService`  [EXTRACTED]
  lib/main.dart → lib/services/language_service.dart
- `_AddEditReminderScreenState` --references--> `MaintenanceService`  [EXTRACTED]
  lib/screens/add_edit_reminder_screen.dart → lib/services/maintenance_service.dart

## Import Cycles
- None detected.

## Communities (52 total, 0 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.03
Nodes (70): app_localizations_en.dart, app_localizations_es.dart, class, dart:async, addToFavorites, alreadyCompleted, appTitle, calculators (+62 more)

### Community 1 - "Community 1"
Cohesion: 0.03
Nodes (59): callTechnicianConditionsEn, callTechnicianConditionsEs, canDoYourselfConditionsEn, canDoYourselfConditionsEs, color, descriptionEn, descriptionEs, difficultyColor (+51 more)

### Community 2 - "Community 2"
Cohesion: 0.03
Nodes (57): app_localizations.dart, addToFavorites, alreadyCompleted, appTitle, calculators, callIf, comingSoon, completed (+49 more)

### Community 3 - "Community 3"
Cohesion: 0.03
Nodes (57): addToFavorites, alreadyCompleted, appTitle, calculators, callIf, comingSoon, completed, couldNotFixIt (+49 more)

### Community 4 - "Community 4"
Cohesion: 0.04
Nodes (44): CalculatorField, CalculatorFieldType, categoryEn, categoryEs, defaultValue, descriptionEn, descriptionEs, disclaimerEn (+36 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (41): calculator_detail_screen.dart, ../data/calculators_data.dart, ../data/emergency_data.dart, CalculatorTool, RepairHistoryEntry, build, _buildEmptyState, _CalculatorCard (+33 more)

### Community 6 - "Community 6"
Cohesion: 0.05
Nodes (40): answers, descriptionEn, descriptionEs, DiagnosticAnswer, DiagnosticQuestion, firstThingsToCheckEn, firstThingsToCheckEs, getDescription (+32 more)

### Community 7 - "Community 7"
Cohesion: 0.05
Nodes (36): IconData, description, descriptionEn, descriptionEs, getDescription, getName, id, name (+28 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (33): call911ConditionsEn, call911ConditionsEs, callTechnicianConditionsEn, callTechnicianConditionsEs, color, DangerLevel, doFirstStepsEn, doFirstStepsEs (+25 more)

### Community 9 - "Community 9"
Cohesion: 0.06
Nodes (28): DiagnosticData, flows, EmergencyData, items, MaintenanceData, suggestions, all, forTrade (+20 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (32): copyWith, createdAt, customDays, descriptionEn, descriptionEs, frequency, fromJson, getDescription (+24 more)

### Community 11 - "Community 11"
Cohesion: 0.09
Nodes (29): ShoppingItem, ShoppingList, _addItem, _addItemController, build, _buildAddInput, _BuyButton, color (+21 more)

### Community 12 - "Community 12"
Cohesion: 0.07
Nodes (28): accent, _checkedSteps, _completedSteps, createState, _diyEvaluationSection, _diyList, icon, _itemList (+20 more)

### Community 13 - "Community 13"
Cohesion: 0.07
Nodes (27): DateTime, double?, double get, int get, affiliateUrl, boughtItems, category, createdAt (+19 more)

### Community 14 - "Community 14"
Cohesion: 0.07
Nodes (27): Exception, _androidApiKey, _androidCertSha1, _androidPackage, _appRestrictionHeaders, _baseUrl, _cacheKey, _cachePrefix (+19 more)

### Community 15 - "Community 15"
Cohesion: 0.08
Nodes (26): accentColor, _buildDot, _buildPage, color, _controller, createState, descEn, descEs (+18 more)

### Community 16 - "Community 16"
Cohesion: 0.08
Nodes (24): calculators_screen.dart, diagnostic_list_screen.dart, emergency_screen.dart, _activeTradeIds, _activeTrades, _buildSearchResults, _categories, color (+16 more)

### Community 17 - "Community 17"
Cohesion: 0.08
Nodes (24): Color get, home_problem.dart, IconData get, Difficulty, RiskLevel, color, copyWith, date (+16 more)

### Community 18 - "Community 18"
Cohesion: 0.09
Nodes (22): accentColor, build, _buildList, color, completed, _confirmReset, createState, dispose (+14 more)

### Community 19 - "Community 19"
Cohesion: 0.10
Nodes (21): FormState, MaintenanceFrequency, MaintenancePriority, AddEditReminderScreen, _AddEditReminderScreenState, build, createState, _descController (+13 more)

### Community 20 - "Community 20"
Cohesion: 0.11
Nodes (19): Future, DiagnosticResult, build, _buildVideoQuery, _buildVideosSection, createState, DiagnosticResultScreen, _DiagnosticResultScreenState (+11 more)

### Community 21 - "Community 21"
Cohesion: 0.12
Nodes (18): ../data/maintenance_data.dart, MaintenanceReminder, _save, build, _EmptyState, _formatDate, lang, _logPostpone (+10 more)

### Community 22 - "Community 22"
Cohesion: 0.12
Nodes (17): add_edit_reminder_screen.dart, _actionButton, build, _buildField, _buildResultCard, CalculatorDetailScreen, _CalculatorDetailScreenState, _controllers (+9 more)

### Community 23 - "Community 23"
Cohesion: 0.12
Nodes (16): Animation, AnimationController, build, createState, _ctrl, dispose, _fade, initState (+8 more)

### Community 24 - "Community 24"
Cohesion: 0.12
Nodes (15): Color, ../data/mock_data.dart, Task, build, task, trade, VideoListScreen, build (+7 more)

### Community 25 - "Community 25"
Cohesion: 0.14
Nodes (14): ChangeNotifier, ../data/problems_data.dart, build, FavoritesScreen, FavoritesService, SeasonalService, build, onTap (+6 more)

### Community 26 - "Community 26"
Cohesion: 0.12
Nodes (15): binding, favoritesService, historyService, languageService, load, main, maintenanceService, seasonalService (+7 more)

### Community 27 - "Community 27"
Cohesion: 0.14
Nodes (14): diagnostic_result_screen.dart, DiagnosticQuestion get, DiagnosticFlow, build, createState, _currentQuestion, _currentQuestionId, DiagnosticScreen (+6 more)

### Community 28 - "Community 28"
Cohesion: 0.14
Nodes (14): TutorialVideo, build, _controller, createState, dispose, initState, _openInYouTube, tradeColor (+6 more)

### Community 29 - "Community 29"
Cohesion: 0.15
Nodes (13): favorites_screen.dart, home_screen.dart, build, createState, _currentIndex, MainShell, MainShellState, of (+5 more)

### Community 30 - "Community 30"
Cohesion: 0.15
Nodes (12): Trade, build, TaskListScreen, trade, build, onTap, trade, TradeCard (+4 more)

### Community 31 - "Community 31"
Cohesion: 0.14
Nodes (14): _createReminder, _goToGuide, _goToGuide, _openVideo, build, _buildHomeContent, _goToDetail, _goToProblemList (+6 more)

### Community 32 - "Community 32"
Cohesion: 0.14
Nodes (13): accent, AppTheme, background, cardShadow, primary, primaryDark, surface, textPrimary (+5 more)

### Community 33 - "Community 33"
Cohesion: 0.15
Nodes (12): ../data/seasonal_data.dart, completedCount, _done, isTaskDone, _key, load, progress, resetSeason (+4 more)

### Community 34 - "Community 34"
Cohesion: 0.21
Nodes (13): CalculatorsScreen, _CalculatorsScreenState, DiagnosticListScreen, _DiagnosticListScreenState, HomeScreen, _HomeScreenState, RepairHistoryScreen, _RepairHistoryScreenState (+5 more)

### Community 35 - "Community 35"
Cohesion: 0.15
Nodes (13): _VideoSuggestionCard, _CompactTradeCard, _DiagnosticChip, _PopularProblemChip, _LangButton, _VideoActionCard, _VideoCarouselCard, _CategoryHeader (+5 more)

### Community 36 - "Community 36"
Cohesion: 0.17
Nodes (12): _allProblems, build, _buildTradeCalculators, createState, dispose, initState, ProblemListScreen, _ProblemListScreenState (+4 more)

### Community 37 - "Community 37"
Cohesion: 0.14
Nodes (13): dart:convert, addReminder, _calculateNextDate, completeReminder, deleteReminder, _isLoading, isReminderActiveForGuide, load (+5 more)

### Community 38 - "Community 38"
Cohesion: 0.17
Nodes (11): addItemToList, addList, getListForGuide, _key, _lists, load, removeItemFromList, removeList (+3 more)

### Community 39 - "Community 39"
Cohesion: 0.18
Nodes (11): EmergencyItem, build, createState, EmergencyDetailScreen, _EmergencyDetailScreenState, _goToGuide, initState, _instructionSection (+3 more)

### Community 40 - "Community 40"
Cohesion: 0.18
Nodes (10): bool get, completeOnboarding, _hasSeenOnboarding, load, _locale, _onboardingKey, _prefKey, setLocale (+2 more)

### Community 41 - "Community 41"
Cohesion: 0.18
Nodes (10): ../data/diagnostic_data.dart, diagnostic_screen.dart, build, createState, _DiagnosticListCard, _filters, flow, _selectedTradeId (+2 more)

### Community 42 - "Community 42"
Cohesion: 0.20
Nodes (9): MockData, tasks, tasksForTrade, tradeForId, trades, videos, videosForIds, videosForTask (+1 more)

### Community 43 - "Community 43"
Cohesion: 0.20
Nodes (10): build, SkillFixApp, initState, _showLanguageSelector, build, _buildLanguagePicker, _complete, initState (+2 more)

### Community 44 - "Community 44"
Cohesion: 0.20
Nodes (9): HomeProblem, accentColor, build, _chip, onTap, problem, ProblemCard, tradeLabel (+1 more)

### Community 45 - "Community 45"
Cohesion: 0.22
Nodes (8): _favoriteIds, isFavorite, _key, load, toggle, package:flutter/foundation.dart, package:shared_preferences/shared_preferences.dart, Set

### Community 46 - "Community 46"
Cohesion: 0.22
Nodes (8): categoryEn, categoryEs, id, isHighPriority, Season, SeasonalTask, titleEn, titleEs

### Community 47 - "Community 47"
Cohesion: 0.22
Nodes (9): _calculate, _showPostponeDialog, build, _createShoppingList, _showHelpDialog, _toggleCompleted, build, _HistoryItemCard (+1 more)

### Community 48 - "Community 48"
Cohesion: 0.29
Nodes (6): emergency_detail_screen.dart, build, _EmergencyCard, EmergencyScreen, item, theme/app_theme.dart

### Community 49 - "Community 49"
Cohesion: 0.33
Nodes (5): CalculatorsData, getCategories, tools, package:flutter/material.dart, static final List

### Community 50 - "Community 50"
Cohesion: 0.40
Nodes (6): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsEs, of, LocalizationsDelegate

### Community 51 - "Community 51"
Cohesion: 0.33
Nodes (5): AffiliateLinks, amazon, _amazonTag, homedepot, static const String

## Knowledge Gaps
- **835 isolated node(s):** `CalculatorsData`, `tools`, `getCategories`, `DiagnosticData`, `flows` (+830 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `TutorialVideo` connect `Community 28` to `Community 7`, `Community 12`, `Community 14`, `Community 20`, `Community 25`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Why does `LanguageService` connect `Community 43` to `Community 34`, `Community 40`, `Community 12`, `Community 15`, `Community 16`, `Community 20`, `Community 23`, `Community 25`, `Community 26`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `RiskLevel` connect `Community 17` to `Community 1`, `Community 6`?**
  _High betweenness centrality (0.008) - this node is a cross-community bridge._
- **What connects `CalculatorsData`, `tools`, `getCategories` to the rest of the system?**
  _835 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.028169014084507043 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.034482758620689655 - nodes in this community are weakly interconnected._