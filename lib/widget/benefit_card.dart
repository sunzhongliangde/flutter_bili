import 'package:flutter/material.dart';

import '../model/profile_model.dart';
import '../util/view_util.dart';
import 'hi_blur.dart';

///增值服务
class BenefitCard extends StatelessWidget {
  final List<Benefit> benefitList;

  const BenefitCard({Key? key, required this.benefitList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), _buildBenefit(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Text('增值服务',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            hiSpace(width: 10),
            Text(
              '购买后登录慕课网再次点击打开查看',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            )
          ],
        ));
  }

  _buildCard(BuildContext context, Benefit mo, double width) {
    return InkWell(
      onTap: () {
        //todo
        print('复制到剪切板与打开H5');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 60,
            decoration: const BoxDecoration(color: Colors.redAccent),
            child: Stack(
              children: [
                const Positioned.fill(child: HiBlur()),
                Positioned.fill(
                    child: Center(
                        child: Text(mo.name,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBenefit(BuildContext context) {
    //根据卡片数量计算出每个卡片的宽度
    var width = (MediaQuery.of(context).size.width -
            20 -
            (benefitList.length - 1) * 5) /
        benefitList.length;
    return Row(
      children: [
        ...benefitList.map((e) => _buildCard(context, e, width)).toSet()
      ],
    );
  }
}
