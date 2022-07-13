import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum LayoutType {
  imageTop, //图上文下
  textTop, //文上图下
  onlyText, //只显示文字
  onlyImage, //只显示图片
}

/// 条目数据
class TabItemData {
  String title;
  Color textDefaultColor;
  Color textSelectedColor;
  double? textSize;
  EdgeInsetsGeometry? textMargin;
  String imgDefaultLocalPath;
  String imgSelectedLocalPath;
  double? imgWidth;
  double? imgHeight;
  EdgeInsetsGeometry? imageMargin;
  Color? imageTintColor; //设置图片颜色 类似Android的tint属性
  Function? onTap;

  TabItemData({
    this.title = "",
    this.textDefaultColor = Colors.white,
    this.textSelectedColor = Colors.red,
    required this.imgDefaultLocalPath,
    required this.imgSelectedLocalPath,
    this.textMargin,
    this.imageMargin,
    this.imgWidth,
    this.imgHeight,
    this.textSize,
    this.imageTintColor,
    this.onTap,
  });
}

class BottomTabBar extends StatelessWidget {
  final ValueChanged<int> onTabClick;
  final List<TabItemData> items;
  final int selectedIndex;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final LayoutType? layoutType;

  BottomTabBar({
    Key? key,
    this.layoutType = LayoutType.imageTop,
    this.padding,
    this.backgroundColor,
    required this.selectedIndex,
    required this.onTabClick,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: backgroundColor ?? Colors.grey,
        ),
        padding: padding,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (int index) {
              return buildItemWidget(index);
            })));
  }

  Widget buildItemWidget(int index) {
    //刷新状态
    var tabItemData = items.elementAt(index);
    return Expanded(
      child: InkWell(
        // borderRadius: BorderRadius.all(Radius.circular(50)),
        onTap: () {
          onTabClick(index);
        },
        child: BottomTabItem(
          item: tabItemData,
          layoutType: layoutType ?? LayoutType.imageTop,
          isSelected: index == selectedIndex,
        ),
      ),
    );
  }
}

/// 底部 Item
class BottomTabItem extends StatelessWidget {
  final TabItemData item;
  final bool isSelected;
  final LayoutType layoutType;

  const BottomTabItem({
    Key? key,
    required this.layoutType,
    required this.item,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            buildBottomTab(),
          ],
        ),
      ],
    );
  }

  ///获取不同模式的布局
  Column buildBottomTab() {
    if (layoutType == LayoutType.textTop) {
      return Column(
        children: <Widget>[_buildText(), _buildImage()],
      );
    } else if (layoutType == LayoutType.onlyImage) {
      return Column(
        children: <Widget>[_buildImage()],
      );
    } else if (layoutType == LayoutType.onlyText) {
      return Column(
        children: <Widget>[_buildText()],
      );
    } else {
      return Column(
        children: <Widget>[_buildImage(), _buildText()],
      );
    }
  }

  Container _buildText() {
    return Container(
      margin: item.textMargin ?? EdgeInsets.symmetric(horizontal: 0),
      child: Offstage(
        offstage: item.title == "",
        child: Text(item.title,
            style: TextStyle(
              color:
                  isSelected ? item.textSelectedColor : item.textDefaultColor,
              fontSize: item.textSize,
            )),
      ),
    );
  }

  Container _buildImage() {
    return Container(
        margin: item.imageMargin ?? EdgeInsets.symmetric(horizontal: 0),
        child: buildColorFiltered());
  }

  Widget buildColorFiltered() {
    if (item.imageTintColor == null) {
      return _buildPicture();
    } else {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
            (item.imageTintColor == null ? Colors.blue : item.imageTintColor!),
            BlendMode.modulate),
        child: _buildPicture(),
      );
    }
  }

  Widget _buildPicture() {
    var imagePath =
        isSelected ? item.imgSelectedLocalPath : item.imgDefaultLocalPath;
    if (imagePath.endsWith(".svg")) {
      return SvgPicture.asset(
        imagePath,
        width: item.imgWidth,
        height: item.imgHeight,
      );
    } else {
      return Image.asset(
        imagePath,
        width: item.imgWidth,
        height: item.imgHeight,
      );
    }
  }
}
