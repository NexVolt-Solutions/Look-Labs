import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Features/ViewModel/my_album_view_model.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:provider/provider.dart';

class MyAlbumScreen extends StatefulWidget {
  const MyAlbumScreen({super.key});

  @override
  State<MyAlbumScreen> createState() => _MyAlbumScreenState();
}

class _MyAlbumScreenState extends State<MyAlbumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyAlbumViewModel>().loadAlbumImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyAlbumViewModel>();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          clipBehavior: Clip.hardEdge,
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: AppText.myAlbum,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(25)),
            if (viewModel.error != null)
              Padding(
                padding: EdgeInsets.only(bottom: context.sh(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        viewModel.error ?? '',
                        style: TextStyle(
                          fontSize: context.sp(12),
                          color: AppColors.notSelectedColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => viewModel.clearError(),
                      child: const Text('Dismiss'),
                    ),
                    TextButton(
                      onPressed: () => viewModel.loadAlbumImages(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            if (viewModel.loading && viewModel.images.isEmpty)
              SizedBox(
                height: context.sh(200),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CupertinoActivityIndicator(
                      color: AppColors.pimaryColor,
                    ),
                  ),
                ),
              )
            else if (viewModel.images.isEmpty)
              SizedBox(
                height: context.sh(200),
                child: Center(
                  child: Text(
                    'No images yet',
                    style: TextStyle(
                      fontSize: context.sp(14),
                      color: AppColors.notSelectedColor,
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 4 / 4,
                ),
                itemCount: viewModel.images.length,
                itemBuilder: (context, index) {
                  final item = viewModel.images[index];
                  return Padding(
                    padding: context.paddingSymmetricR(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item.url.isNotEmpty
                          ? Image.network(
                              item.url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppColors.backGroundColor,
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColors.pimaryColor,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, _, _) => Container(
                                color: AppColors.backGroundColor,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 32,
                                  color: AppColors.notSelectedColor,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.backGroundColor,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 32,
                                color: AppColors.notSelectedColor,
                              ),
                            ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
