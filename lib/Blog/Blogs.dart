import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/Blog/OwnBlog.dart';
import 'package:blogapp/Blog/addBlog.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:blogapp/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key, required this.type, required this.posts});
  final String type;
  final List posts;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  List<dynamic> data = [];
  bool isLoading = true;
  String trimmedText = '';
  String text = '';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredData = [];
  String username = '';
  Map<String, dynamic> userDetails = {};
  List<dynamic> uniqueCategory = ['All'];
  String selectedCategory = 'All';

  @override
  void initState() {
    // print(widget.posts);
    // TODO: implement initState
    userDetails = getUserDetails();
    // print(userDetails);
    data = widget.posts;
    filteredData = data;
    // print(filteredData);
    if (widget.type == 'Public') {
      for (var post in data) {
        String categoryTitle = post['category']['title'];

        if (!uniqueCategory.contains(categoryTitle)) {
          uniqueCategory.add(categoryTitle);
        }
      }
    }

    if (filteredData.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
    super.initState();
  }

  void filterBlogPosts(String query) {
    setState(() {
      filteredData = data.where((item) {
        String title = item["title"].toLowerCase();
        String body = item["description"].toLowerCase();
        String fullname = item['user']["fullname"].toLowerCase();
        return title.contains(query.toLowerCase()) ||
            body.contains(query.toLowerCase()) ||
            fullname.contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterOwnBlogPosts(String query) {
    setState(() {
      filteredData = data.where((item) {
        String title = item["title"].toLowerCase();
        String body = item["description"].toLowerCase();
        return title.contains(query.toLowerCase()) ||
            body.contains(query.toLowerCase());
      }).toList();
    });
  }

  filterPostsByCategory(String categoryName) {
    if (categoryName == 'All') {
      categoryName = '';
    }
    setState(() {
      filteredData = data.where((item) {
        String category = item['category']["title"].toLowerCase();
        return category.contains(categoryName.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {}, // Callback function to fetch data
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorTheme(context)['fillColor'],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.type == "Public"
                              ? filterBlogPosts
                              : filterOwnBlogPosts,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 35,
                        child: IconButton(
                          icon: const Icon(Icons.cancel),
                          color: colorTheme(context)['button'],
                          onPressed: () {
                            _searchController.clear();
                            widget.type == "Public"
                                ? filterBlogPosts('')
                                : filterOwnBlogPosts('');
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.type == 'Public'
                  ? Wrap(
                      alignment: WrapAlignment
                          .start, // Aligns the buttons to the start (left side)
                      spacing: 8.0, // Horizontal spacing between buttons
                      runSpacing: 4.0, // Vertical spacing between rows
                      children: uniqueCategory.map((category) {
                        final isSelected = selectedCategory ==
                            category; // Check if this category is selected
                        return OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory =
                                  category; // Set the selected category on button click
                            });
                            filterPostsByCategory(category);
                            // print(category);
                          },
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? colorTheme(context)['buttonText']
                                  : colorTheme(context)['button'],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              side: BorderSide(
                                  color: isSelected
                                      ? colorTheme(context)[
                                          'button'] // Outline color when selected
                                      : colorTheme(context)[
                                          'tertiary'] // Outline color when not selected
                                  ),
                              backgroundColor: isSelected
                                  ? colorTheme(context)['button']
                                  : colorTheme(context)['buttonText']),
                        );
                      }).toList(),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              ...filteredData.map((item) => InkWell(
                    onTap: widget.type == "Public"
                        ? () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Blog(post: item),
                              ),
                            );
                            print(result);

                            if (result != null) {
                              setState(() {
                                result['likesCount'] =
                                    item['likesCount'].toString();
                                result['likes'] = item['likes'];
                                result['dislikesCount'] =
                                    item['dislikesCount'].toString();
                                result['dislikes'] = item['dislikes'];
                                result['numViews'] = item['numViews'];
                                result['viewsCount'] = item['viewsCount'];
                                result['followers'] = item['user']['followers'];
                                result['following'] = item['user']['following'];
                              });
                              // print(item);
                            }
                          }
                        : () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OwnBlog(post: item),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                result['likesCount'] =
                                    item['likesCount'].toString();
                                result['likes'] = item['likes'];
                                result['dislikesCount'] =
                                    item['dislikesCount'].toString();
                                result['dislikes'] = item['dislikes'];
                                // result['numViews'] = item['numViews'];
                                // result['viewsCount'] = item['viewsCount'];
                              });
                              // print(item);
                            }
                          },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(12),
                      //   gradient: const LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //       Color.fromARGB(255, 147, 222, 151), // Darker green
                      //       Color.fromARGB(255, 173, 236, 178), // Medium green
                      //       Color.fromARGB(255, 194, 239, 194), // Lighter green
                      //     ],
                      //   ),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.2),
                      //       spreadRadius: 5,
                      //       blurRadius: 7,
                      //       offset: Offset(0, 3), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                      color: colorTheme(context)['secondary'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row: CircleAvatar, Fullname, and PopupMenuButton
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // CircleAvatar with profile photo
                                widget.type == "Public"
                                    ? (item['user']['profilePhoto'] != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                item['user']['profilePhoto']),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          )
                                        : const CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/nouser.png'),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          ))
                                    : (userDetails["photo"] != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userDetails["photo"]),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          )
                                        : const CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/nouser.png'),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          )),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.type == "Public"
                                          ? Text(
                                              item['user']['fullname'],
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: colorTheme(
                                                      context)['text'],
                                                ),
                                              ),
                                            )
                                          : Text(
                                              userDetails['fullname'],
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: colorTheme(
                                                      context)['text'],
                                                ),
                                              ),
                                            ),
                                      Text(
                                        item['daysAgo'],
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            color:
                                                colorTheme(context)['daysago'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // print(item['_id']);
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottomSheet(item['_id'])),
                                      );
                                    },
                                    child: Text(
                                      "•••",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: colorTheme(context)['text'],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 2.0, left: 8.0),
                          //   child: Text(
                          //     "#${item['category']['title']}",
                          //     style: GoogleFonts.poppins(
                          //       textStyle: const TextStyle(
                          //         // fontWeight: FontWeight.bold,
                          //         fontSize: 14,
                          //         color: Colors.blue,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Post Image
                          if (item['photo'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                item['photo'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                          // Post Description or Title
                          if (item['title'] != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 12.0),
                              child: Text(
                                item['title'],
                                // "vyhfytfyt ftyfytfdytf fyfytytfy ftys4aarest tguyviugi",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorTheme(context)['text'],
                                  ),
                                ),
                              ),
                            ),
                          // Post Interaction
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Views text on the left

                                // Likes text on the right
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_up,
                                      size: 22,
                                      color: colorTheme(context)['tertiary'],
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Space between icon and text
                                    Text(
                                      item['likesCount'].toString(),
                                      style: TextStyle(
                                        color: colorTheme(context)['text'],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.visibility,
                                      size: 22,
                                      color: colorTheme(context)['tertiary'],
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Space between icon and text
                                    Text(
                                      item['viewsCount'].toString(),
                                      style: TextStyle(
                                        color: colorTheme(context)['text'],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget bottomSheet(id) {
    var foundPost = widget.posts.firstWhere((post) => post["_id"] == id);
    // print(foundPost);
    return Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: colorTheme(context)['primary'],
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              elevation: 4.0,
              child: Container(
                width: double.infinity, // Make the card full width
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text and Arrow Pair 1
                    GestureDetector(
                      onTap: () {
                        // Add your click event logic here
                        // print('Edit Row clicked');

                        Navigator.pop(context);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AddBlog(action: "Edit", data: foundPost)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Edit Post',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: colorTheme(context)['tertiary'],
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          Text(
                            'Subtext 2',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Text and Arrow Pair 2
                    Divider(height: 20, color: Colors.grey[300]),
                    SizedBox(height: 16), // Space between pairs

                    // Text and Arrow Pair 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Delete Post',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorTheme(context)['tertiary'],
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(height: 20, color: Colors.grey[300]),
                    SizedBox(height: 16), // Space between pairs

                    // Text and Arrow Pair 4
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Block User',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorTheme(context)['tertiary'],
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 4',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + ' more...';
    }
  }
}
