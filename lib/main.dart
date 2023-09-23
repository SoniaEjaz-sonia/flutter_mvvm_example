import 'dart:math';

import 'package:flutter/material.dart';
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
          '/': (context) => const ScrollToItemPosition(),
        },
      ),
    );
  }
}

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
