import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/apis/api_response.dart';
import '../model/media.dart';
import '../view_model/media_view_model.dart';
import 'widgets/player_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final inputController = TextEditingController();

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    List<Media>? mediaList = apiResponse.data as List<Media>?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: PlayerListWidget(
                mediaList: mediaList!,
                function: (Media media) {
                  Provider.of<MediaViewModel>(context, listen: false).setSelectedMedia(media);
                },
              ),
            ),
          ],
        );
      case Status.ERROR:
        return const Center(
          child: Text('Please try again latter!!!'),
        );
      case Status.INITIAL:
      default:
        return const Center(
          child: Text(''),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: Center(
          child: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              onPressed: () {},
              padding: const EdgeInsets.only(left: 15),
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            title: const Text('ORG.CHART'),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: TextField(
              controller: inputController,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search USer/ID',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Provider.of<MediaViewModel>(context, listen: false).setSelectedMedia(null);
                  Provider.of<MediaViewModel>(context, listen: false).fetchMediaData(value);
                }
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30),
          //   child: Stack(
          //     alignment: Alignment.bottomCenter,
          //     fit: StackFit.passthrough,
          //     clipBehavior: Clip.none,
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.grey,
          //           border: Border.all(color: Colors.grey),
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: const Icon(
          //           Icons.person,
          //           size: 100,
          //           color: Colors.deepPurple,
          //         ),
          //       ),
          //       Positioned(
          //         bottom: -14,
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //           decoration: BoxDecoration(
          //             color: Theme.of(context).scaffoldBackgroundColor,
          //             border: Border.all(color: Colors.black),
          //             borderRadius: BorderRadius.circular(5),
          //           ),
          //           child: const Text("5"),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 35),
          // const Text(
          //   "Team Leader",
          //   style: TextStyle(fontWeight: FontWeight.w600),
          // ),
          // const SizedBox(height: 5),
          // const Text(
          //   "HC Careline",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //   ),
          // ),
          // const SizedBox(
          //   height: 30,
          //   child: VerticalDivider(thickness: 1.5),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Divider(),
          // ),
          Expanded(child: getMediaWidget(context, apiResponse)),
        ],
      ),
    );
  }
}
