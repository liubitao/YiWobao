//
//  YWport.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#ifndef YWport_h
#define YWport_h

//接口
#define  sKey               @"b8036a5e528d50d8ea8299328f08c020"

//登录接口
#define YWLogin             @"http://api.yiwob.com/shop/ywbapp.php/Index/doLogin"
#define login               @"doLogin"

//修改会员资料接口
#define YWEdit              @"http://api.yiwob.com/shop/ywbapp.php/Member/editInfo1"
#define Edit                @"edit_info1"

//获取手机验证码
#define YWCode              @"http://api.yiwob.com/shop/ywbapp.php/Member/getCode"
#define Code                @"get_code"

//修改登录、支付密码
#define YWEdit2             @"http://api.yiwob.com/shop/ywbapp.php/Member/editInfo2"
#define Edit2               @"edit_info2"

//获取总裁，总监，经理信息
#define YWList              @"http://api.yiwob.com/shop/ywbapp.php/Member/zcList"
#define List                @"zc_list"

//获取充值、提现、转账、收益、支出记录
#define YWTrlist            @"http://api.yiwob.com/shop/ywbapp.php/Member/trList"
#define Trlist              @"tr_list"

//获取所有订单、推荐人代付订单、我要代付订单
#define YWOrderList         @"http://api.yiwob.com/shop/ywbapp.php/Member/orderList"
#define OrderList           @"order_list"

//图片的前缀
#define  YWpic              @"http://api.yiwob.com"

//二维码
#define  YWShareCode        @"http://api.yiwob.com/shop/"

//提现
#define  YWPick             @"http://api.yiwob.com/shop/ywbapp.php/Member/pickCash"
#define  Pick               @"pick_cash"

//地址列表
#define YWAddrList          @"http://api.yiwob.com/shop/ywbapp.php/Member/addrList"
#define Addres              @"addr_list"

//添加，修改收货地址
#define YWAddaddr           @"http://api.yiwob.com/shop/ywbapp.php/Member/addAddr"
#define Addaddr             @"add_addr"

//删除，设置默认地址
#define YWSetAddr           @"http://api.yiwob.com/shop/ywbapp.php/Member/setAddr"
#define SetAddr             @"set_addr"

//获取会员信息
#define YWGetinfo           @"http://api.yiwob.com/shop/ywbapp.php/Goods/getinfo"
#define Getinfo             @"get_info"


//转账
#define YWTrans             @"http://api.yiwob.com/shop/ywbapp.php/Member/transTo"
#define Trans               @"trans_to"


//商品搜索
#define YWSearch            @"http://api.yiwob.com/shop/ywbapp.php/Goods/goodsSearch"
#define Search              @"goods_search"

//商城所有的商品和分类
#define YWGood             @"http://api.yiwob.com/shop/ywbapp.php/Goods/goodsList"
#define Good               @"goods_list"

//商品详情列表
#define YWgoodsDetail      @"http://api.yiwob.com/shop/ywbapp.php/Goods/goodsDetail"
#define goodsDetails       @"goods_detail"

//直接购买、跳转到购买界面
#define YWGoodBuy          @"http://api.yiwob.com/shop/ywbapp.php/Member/goodsBuy"
#define Goods_buy          @"goods_buy"

//直接购买,提交表单
#define YWGoodsOrder       @"http://api.yiwob.com/shop/ywbapp.php/Member/goodsOrder"
#define Goods_order        @"goods_order"

//取消、拒绝代付订单
#define YWDelOrder         @"http://api.yiwob.com/shop/ywbapp.php/Member/delOrder"
#define Del_order          @"del_order"

//代付表单处理
#define YWDoOrder          @"http://api.yiwob.com/shop/ywbapp.php/Member/doDfOrder"
#define do_order           @"do_df_order"

//查看代付码
#define YWSeeEwm           @"http://api.yiwob.com/shop/ywbapp.php/Member/seeEwm"
#define SeeEwm             @"do_pay_order"

//推广链接
#define YWShare            @"http://api.yiwob.com/shop/ywbapp.php/Member/shareMe"
#define Share              @"share_me"

//福利认购
#define YWzcproj           @"http://api.yiwob.com/shop/ywbapp.php/Goods/zcprojList"
#define zcproj             @"zcproj_list"

//福利详情
#define YWdetail           @"http://api.yiwob.com/shop/ywbapp.php/Member/zcprojDetail"
#define detail             @"zcproj_detail"

//我的福利列表
#define YWmyProj           @"http://api.yiwob.com/shop/ywbapp.php/Member/myProj"
#define myProj             @"my_proj"

//我要认领支付接口
#define YWbuyProj          @"http://api.yiwob.com/shop/ywbapp.php/Member/buyProj"
#define buyProj            @"buy_proj"

//申请回购
#define YWgetBack           @"http://api.yiwob.com/shop/ywbapp.php/Member/getBack"
#define getBack             @"buy_proj"

//商户中心接口
#define YWmyshop            @"http://api.yiwob.com/shop/ywbapp.php/Member/myShop"
#define my_shop             @"my_shop"

//扫码后的
#define YWshop_pay          @"http://api.yiwob.com/shop/ywbapp.php/Member/shopPay"
#define shop_pay            @"shop_pay"

//支付商户
#define YWshopDpay          @"http://api.yiwob.com/shop/ywbapp.php/Member/shopDPay"
#define shop_dpay           @"shop_dpay"

//获取所有联盟商家
#define YWshopList          @"http://api.yiwob.com/shop/ywbapp.php/Goods/shopsList"
#define shops_list          @"shops_list"

//免费商品
#define YWFreeGoods         @"http://api.yiwob.com/shop/textindex.php"

#endif /* YWport_h */