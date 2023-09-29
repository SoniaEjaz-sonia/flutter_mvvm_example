import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'view_model/media_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MediaViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text('Search Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter BottomNavigationBar Example'), backgroundColor: Colors.green),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.green),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search', backgroundColor: Colors.yellow),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: const ListTile(title: Text('Slide me')),
          ),
          Slidable(
            key: const ValueKey(1),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: const ListTile(title: Text('Slide me')),
          ),
        ],
      ),
    );
  }
}

// class Home extends StatefulWidget {
//   const Home({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   // This is used to monitor the item index in the list, and later used to closeup or leave open the slide.
//   int resetSlideIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Class List"),
//       ),
//       body: ListView.separated(
//         itemCount: _classList.length,
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 20,
//         ),
//         itemBuilder: (context, index) {
//           Map<String, dynamic> student = _classList[index];
//           return GestureDetector(
//             onLongPressDown: (val) {
//               setState(() {
//                 resetSlideIndex = index;
//               });
//             },
//             child: _listItem(
//               context: context,
//               student: student,
//               index: index,
//               resetSlide: index == resetSlideIndex ? false : true,
//             ),
//           );
//         },
//         separatorBuilder: (context, index) => const SizedBox(height: 10),
//       ),
//     );
//   }
//
//   Slideable _listItem({
//     required BuildContext context,
//     required Map<String, dynamic> student,
//     required int index,
//     required bool resetSlide,
//   }) {
//     return Slideable(
//       resetSlide: resetSlide,
//       actions: <Widget>[
//         IconSlideAction(
//           icon: Icons.close,
//           caption: 'Delete',
//           color: Theme.of(context).accentColor,
//           onTap: () {
//             setState(() {
//               todos.removeAt(i);
//             });
//           },
//         )
//       ],
//       items: <ActionItems>[
//         ActionItems(
//           icon: const Icon(
//             Icons.thumb_up,
//             color: Colors.blue,
//           ),
//           onPress: () => _likeUser(student["name"]),
//           backgroudColor: Colors.transparent,
//         ),
//         ActionItems(
//           icon: const Icon(
//             Icons.delete,
//             color: Colors.red,
//           ),
//           onPress: () => _deleteUser(student["name"]),
//           backgroudColor: Colors.transparent,
//         ),
//       ],
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 10,
//           vertical: 12,
//         ),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 214, 214, 214),
//           border: Border.all(
//             width: 1,
//             color: const Color.fromARGB(124, 158, 158, 158),
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(
//                 color: Colors.grey[350],
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.white,
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: Image.network(
//                   student["img"],
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 5,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Name",
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     student["name"],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               "#${index + 1}",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _deleteUser(user) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("$user, will be deleted."),
//         backgroundColor: Colors.grey[450],
//       ),
//     );
//   }
//
//   _likeUser(user) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("You gave $user a thumbs up, pretty cool 🥰"),
//         backgroundColor: Colors.grey[450],
//       ),
//     );
//   }
//
//   final List<Map<String, dynamic>> _classList = [
//     {
//       "name": "Ikwegbu George",
//       "img": "https://images.pexels.com/photos/2379429/pexels-photo-2379429.jpeg?auto=compress&cs=tinysrgb&w=1600",
//     },
//     {
//       "name": "Phoebe Pelumi",
//       "img":
//           "https://images.pexels.com/photos/3986672/pexels-photo-3986672.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load",
//     },
//     {
//       "name": "James Mike",
//       "img":
//           "https://images.pexels.com/photos/11828983/pexels-photo-11828983.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load",
//     },
//     {
//       "name": "Abigail Ezinne",
//       "img":
//           "https://images.pexels.com/photos/3030252/pexels-photo-3030252.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load",
//     },
//     {
//       "name": "Chioma Chinedu",
//       "img": "https://images.pexels.com/photos/4491630/pexels-photo-4491630.jpeg?auto=compress&cs=tinysrgb&w=1600",
//     },
//   ];
// }

const numberOfItems = 5001;
const minItemHeight = 20.0;
const maxItemHeight = 150.0;
const scrollDuration = Duration(seconds: 2);

const randomMax = 1 << 32;

class ScrollToItemPosition extends StatefulWidget {
  const ScrollToItemPosition({super.key});

  @override
  State<ScrollToItemPosition> createState() => _ScrollToItemPositionState();
}

class _ScrollToItemPositionState extends State<ScrollToItemPosition> {
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Controller to scroll a certain number of pixels relative to the current
  /// scroll offset.
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late List<double> itemHeights;
  late List<Color> itemColors;
  bool reversed = false;

  /// The alignment to be used next time the user scrolls or jumps to an item.
  double alignment = 0;

  @override
  void initState() {
    super.initState();
    final heightGenerator = Random(328902348);
    final colorGenerator = Random(42490823);
    itemHeights = List<double>.generate(
        numberOfItems, (int _) => heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) + minItemHeight);
    itemColors =
        List<Color>.generate(numberOfItems, (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OrientationBuilder(
        builder: (context, orientation) => Column(
          children: <Widget>[
            Expanded(
              child: list(orientation),
            ),
            positionsView,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    scrollControlButtons,
                    scrollOffsetControlButtons,
                    const SizedBox(height: 10),
                    jumpControlButtons,
                    alignmentControl,
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get alignmentControl => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text('Alignment: '),
          SizedBox(
            width: 200,
            child: SliderTheme(
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: alignment,
                label: alignment.toStringAsFixed(2),
                onChanged: (double value) => setState(() => alignment = value),
              ),
            ),
          ),
        ],
      );

  Widget list(Orientation orientation) => ScrollablePositionedList.builder(
        itemCount: numberOfItems,
        itemBuilder: (context, index) => item(index, orientation),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetController: scrollOffsetController,
        reverse: reversed,
        scrollDirection:
            // orientation == Orientation.portrait ? Axis.vertical :
            Axis.horizontal,
      );

  Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
        valueListenable: itemPositionsListener.itemPositions,
        builder: (context, positions, child) {
          int? min;
          int? max;
          if (positions.isNotEmpty) {
            min = positions
                .where((ItemPosition position) => position.itemTrailingEdge > 0)
                .reduce((ItemPosition min, ItemPosition position) =>
                    position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
                .index;

            max = positions
                .where((ItemPosition position) => position.itemLeadingEdge < 1)
                .reduce((ItemPosition max, ItemPosition position) =>
                    position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
                .index;
          }
          return Row(
            children: <Widget>[
              Expanded(child: Text('First Item: ${min ?? ''}')),
              Expanded(child: Text('Last Item: ${max ?? ''}')),
              const Text('Reversed: '),
              Checkbox(
                  value: reversed,
                  onChanged: (bool? value) => setState(() {
                        reversed = value!;
                      }))
            ],
          );
        },
      );

  Widget get scrollControlButtons => Row(
        children: <Widget>[
          const Text('scroll to'),
          scrollItemButton(0),
          scrollItemButton(5),
          scrollItemButton(10),
          scrollItemButton(100),
          scrollItemButton(1000),
          scrollItemButton(5000),
        ],
      );

  Widget get scrollOffsetControlButtons => Row(
        children: <Widget>[
          const Text('scroll by'),
          scrollOffsetButton(-1000),
          scrollOffsetButton(-100),
          scrollOffsetButton(-10),
          scrollOffsetButton(10),
          scrollOffsetButton(100),
          scrollOffsetButton(1000),
        ],
      );

  Widget get jumpControlButtons => Row(
        children: <Widget>[
          const Text('jump to'),
          jumpButton(0),
          jumpButton(5),
          jumpButton(10),
          jumpButton(100),
          jumpButton(1000),
          jumpButton(5000),
        ],
      );

  ButtonStyle _scrollButtonStyle({required double horizonalPadding}) => ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: horizonalPadding, vertical: 0),
        ),
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  Widget scrollItemButton(int value) => TextButton(
        key: ValueKey<String>('Scroll$value'),
        onPressed: () => scrollTo(value),
        style: _scrollButtonStyle(horizonalPadding: 10),
        child: Text('$value'),
      );

  Widget scrollOffsetButton(int value) => TextButton(
        key: ValueKey<String>('Scroll$value'),
        onPressed: () => scrollBy(value.toDouble()),
        style: _scrollButtonStyle(horizonalPadding: 5),
        child: Text('$value'),
      );

  Widget scrollPixelButton(int value) => TextButton(
        key: ValueKey<String>('Scroll$value'),
        onPressed: () => scrollTo(value),
        style: _scrollButtonStyle(horizonalPadding: 10),
        child: Text('$value'),
      );

  Widget jumpButton(int value) => TextButton(
        key: ValueKey<String>('Jump$value'),
        onPressed: () => jumpTo(value),
        style: _scrollButtonStyle(horizonalPadding: 10),
        child: Text('$value'),
      );

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index, duration: scrollDuration, curve: Curves.easeInOutCubic, alignment: alignment);

  void scrollBy(double offset) =>
      scrollOffsetController.animateScroll(offset: offset, duration: scrollDuration, curve: Curves.easeInOutCubic);

  void jumpTo(int index) => itemScrollController.jumpTo(index: index, alignment: alignment);

  /// Generate item number [i].
  Widget item(int i, Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? itemHeights[i] : null,
      width: orientation == Orientation.landscape ? itemHeights[i] : null,
      child: Container(
        color: itemColors[i],
        child: Center(
          child: Text('Item $i'),
        ),
      ),
    );
  }
}

class CenteredListView extends StatefulWidget {
  const CenteredListView({super.key});

  @override
  State<CenteredListView> createState() => _CenteredListViewState();
}

class _CenteredListViewState extends State<CenteredListView> {
  final ScrollController _scrollController = ScrollController();

  List<String> itemList = List.generate(100, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centered ListView'),
      ),
      body: SizedBox(
        height: 56,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: itemList
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      if (_scrollController.hasClients) {
                        // double scrollTo = (index * _getItemHeight()) - (_getScreenHeight() / 2);
                        //
                        // print(_scrollController.position.maxScrollExtent);
                        // print(MediaQuery.of(context).size.width / 2);
                        //
                        // double scrollTo = scrollTo.clamp(0.0, (MediaQuery.of(context).size.width / 2));
                        //
                        _scrollController.animateTo(
                          MediaQuery.of(context).size.width / 2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Card(
                      child: Text(e),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _scrollToItem(int index) {
    if (_scrollController.hasClients) {
      double scrollTo = (index * _getItemHeight()) - (_getScreenHeight() / 2);

      scrollTo = scrollTo.clamp(0.0, (MediaQuery.of(context).size.width / 2));

      _scrollController.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  double _getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _getItemHeight() {
    // Adjust this value based on your item's height or any padding/margin
    return 56.0; // Example height; change as needed
  }
}
