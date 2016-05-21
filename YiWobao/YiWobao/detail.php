<?php
session_start();
header("Content-Type:text/html;charset=UTF-8");
require_once "./common/conn.php";
require_once "./common/sqlin.php";

require_once "jssdk.class.php";
$weixin = new jssdk();
$wx = $weixin->get_sign();

if($debug==1)
{
	var_dump($_REQUEST);
	var_dump($_SESSION);
}

function pregft($matches)
{
    return '@E' . base64_encode($matches[0]);
}
function pregftbk($matches)
{
    return base64_decode($matches[1]);
}


if(isset($_REQUEST['id']))
    $_SESSION[$PRE.'goodsid']=trim($_REQUEST['id']);


$truemrpid=2;

$mrpid=$truemrpid;   //父级ID问题
if(isset($_REQUEST['tjid']) && intval($_REQUEST['tjid'])>0)
{
    $_SESSION[$PRE."tjid"]=$_REQUEST['tjid'];
    $mrpid=$_SESSION[$PRE."tjid"];
    if(isset($_SESSION[$PRE.'openid']) && $_SESSION[$PRE.'openid']<>"")
    {
        $rsmem=$pdodbh->query("select * from member where (not id=".$mrpid.") and (not ".$mrpid." in (select id from member where pid=".$_SESSION[$PRE.'userid'].")) and (not ".$mrpid." in (select id from member where pid in (select id from member where pid=".$_SESSION[$PRE.'userid']."))) and userkind=0 and openid='".$_SESSION[$PRE.'openid']."'");
        if($rowmem=$rsmem->fetch())
        {
            $rsup=$pdodbh->exec("update member set pid=".$mrpid." where id=".$_SESSION[$PRE.'userid']);
        }
    }
}
if(isset($_SESSION[$PRE."tjid"]))
{
    $mrpid=$_SESSION[$PRE."tjid"];
}


//$_SESSION[$PRE.'openid']='oRvKxsyWj0_Gs1mOuYB0RPKG7CCU';
//$_SESSION[$PRE.'openid']="";

if(!isset($_SESSION[$PRE.'openid']) or $_SESSION[$PRE.'openid']=="")
{
    if(isset($_GET["code"])){
        $code = $_GET["code"];

        $arr = $weixin->get_openid($code);

        $access_token = $arr["access_token"];

        $openid = $arr["openid"];


        $sql = "select id from member where openid ='" . $openid . "'  ";  //子节点数字
        $res = $pdodbh->prepare($sql);
        $res->execute();
        $num = $res->rowCount();

        if($num<1)
        {
            $userinfo = $weixin->get_user1($access_token,$openid);//通过openid获取用户信,有可能会弹出窗口
            $userinfo['nickname'] = preg_replace_callback('/[\xf0-\xf7].{3}/', "pregft", $userinfo['nickname'] );

            $sql = "insert into member(pid,openid,wxname,usersex,userimg,logtime,chmoney,regtime) values(".$mrpid.",'".$userinfo['openid'] ."','".$userinfo['nickname']."',".$userinfo['sex'].",'".$userinfo['headimgurl']."',".time().",0,".time().")";

            //echo $sql;

            $res=$pdodbh->exec($sql);
            //echo $res;

        }else
        {
            //该会员存在 如果 带 tjid进来，说明tjid和默认不一致，这时候需要修改会员的父节点。
            $_SESSION[$PRE.'openid']=$openid;

            $result=$pdodbh->query("select * from member where openid ='" . $_SESSION[$PRE.'openid'] . "'");
            if($rowmb=$result->fetch()){
                $_SESSION[$PRE.'userid']=$rowmb['id'];
                $_SESSION[$PRE.'openid']=$rowmb['openid'];
            }
            $result->closeCursor();

            if(isset($_SESSION[$PRE."tjid"]))
            {
                $rsmem=$pdodbh->query("select * from member where (not id=".$mrpid.") and (not ".$mrpid." in (select id from member where pid=".$_SESSION[$PRE.'userid'].")) and (not ".$mrpid." in (select id from member where pid in (select id from member where pid=".$_SESSION[$PRE.'userid']."))) and userkind=0 and openid='".$_SESSION[$PRE.'openid']."'");
                if($rowmem=$rsmem->fetch())
                {
                    $rsup=$pdodbh->exec("update member set pid=".$mrpid." where id=".$_SESSION[$PRE.'userid']);
                }
            }

            $userinfo = $weixin->get_user1($access_token,$openid);//通过openid获取用户信,有可能会弹出窗口
            $rsup2=$pdodbh->exec("update member set userimg='".$userinfo['headimgurl']."',logcount=logcount+1,logtime=".time()." where id=".$_SESSION[$PRE.'userid']);

        }
        $result=$pdodbh->query("select * from member where openid ='" . $_SESSION[$PRE.'openid'] . "'");
        if($rowmb=$result->fetch()){
            $_SESSION[$PRE.'userid']=$rowmb['id'];
            $_SESSION[$PRE.'openid']=$rowmb['openid'];
        }
        $result->closeCursor();



        //var_dump($userinfo);
    }else{
        //$weixin->get_code("http://weixin10.sinaapp.com/jssdk-demo.php","snsapi_base");
        $weixin->get_code($GETURL."detail.php","snsapi_userinfo");
        //获取code,	snsapi_base不弹出, 弹出为snsapi_userinfo
    }

    if($_SESSION[$PRE.'openid']=='')
    {
        echo '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
        echo "<script type='text/javascript'>window.location.href='index.php';</script>";
        exit;
    }


}


$result=$pdodbh->query("select * from member where openid ='" . $_SESSION[$PRE.'openid'] . "'");
if($row=$result->fetch()){
    $_SESSION[$PRE.'userid']=$row['id'];
    $_SESSION[$PRE.'openid']=$row['openid'];
    //$_SESSION[$PRE.'nickname']=$row['nickname'];
    $_SESSION[$PRE.'wxname']=preg_replace_callback('/@E(.{6}==)/', "pregftbk",$row['wxname']);
    $_SESSION[$PRE.'username']=$row['username'];
    $_SESSION[$PRE.'userkind']=$row['userkind'];
    $_SESSION[$PRE.'userimg']=$row['userimg'];
    $_SESSION[$PRE.'phone']=$row['phone'];
    $zctime=$row['regtime'];

}
$result->closeCursor();

$id=0;
if(isset($_SESSION[$PRE.'goodsid']))
	$id=$_SESSION[$PRE.'goodsid'];

if( $_SESSION[$PRE.'userid']==1)
{
	var_dump($_SESSION);
}

if($id==0)
{
	echo '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
	echo "<script type='text/javascript'>alert('输入错误');window.location.href='index.php';</script>";
	exit;
}

$result=$pdodbh->query("select * from goods where gstatus=1 and id =".$id);
if(!$row=$result->fetch()){
	echo '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
	echo "<script type='text/javascript'>alert('输入错误');window.location.href='index.php';</script>";
	exit;		
}
$result->closeCursor();

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>商品详情</title>
    <meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0, user-scalable=0">
    <meta name="keywords" content="猛赚商城">
    <meta name="Description" content="猛赚商城">
    <link href="public/home_css/base.css" rel="stylesheet" type="text/css" />
    <link href="public/home_css/common.css" rel="stylesheet" type="text/css" />
    <link href="public/home_css/page02.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="public/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="public/js/jquery.zclip.min.js"></script>

    <script type="text/javascript">
        $(function(){
            thisNum=$("#buyNum").val();
            num=parseInt(thisNum,10);
            thisPrice=$(".pri").html();
            price=thisPrice;
			
            $(".buyAmount a").click(function(){
                var numName=$(this).attr("class");
                if(numName=="buyRedu"&&num>1){
                    num -= 1;
                }else if(numName=="buyRlus"){
                    num += 1;
                };
                $("#buyNum").attr("value",num);
                $("#buyTotal").val((num*price).toFixed(2));
            });
            $("#buyNum").keyup(function(){
                $("#buyTotal").val(num*price);
            });
            $("#buyNum").blur(function(){
                if(thisNum==""||num<=0){
                    $("#buyNum").attr("value",1);
                    $("#buyTotal").val(price);
                }
            });
            $("#sub").on('click',function(){
                var pmoney = $("#buyTotal").val();
                $("input[name='pmoney']").val(pmoney);
            });

        });
    </script>
</head>
<body>
<form name="form1" method="post" action="order.php">
    <div id="wrapper">
        <header>
            <a class="back" href="javascript:history.back(-1)">&lt;</a>
            <h1>商品详情</h1>
        </header>
        <div class="goods-data">
            <div class="goods_photo">
                    <img src="<?php echo $row["pic"]?>" />
            </div>
            <div class="goods_price">
                <span class="memberPrice">¥<strong class="pri"><?php echo sprintf("%.2f", $row["selprice"]);?></strong></span>
                <span class="commonPrice">￥<?php echo sprintf("%.2f", $row["price"]);?></span>
                <p class="sell-out">已售出<?php echo $row["selnum"]?>件</p>
            </div>
            <div class="goods-buy">
                <div class="goods-buy1">
                    <span class="buy-title">购买数量：</span>
                    <div class="buyAmount">
                        <a class="buyRedu">-</a>
                        <input type="text" name="num" value="1" id="buyNum">
                        <a class="buyRlus">+</a>
                    </div>
                </div>
                <div class="goods-buy1">
                    <span class="buy-title">购买总价：</span>
                    <em style="color: #ff6b6b">¥</em>
                    <input type="text" id="buyTotal" value="<?php echo sprintf("%.2f", $row["selprice"]);?>" disabled style="border:0;background: 0" autocomplete="off"/>
                </div>
        	</div>
            <div class="goods_instro">
                <h2><?php echo $row["title"]?></h2>
                <p class="goods_brief"><?php echo $row["descrition"]?></p>
            </div>
        </div>
        
    </div>
    <div class="buy-list">
        <a href="index.php" id="copy_input" class="">返回首页</a>
        <input type="hidden" name="good_id" value="<?php echo $row["id"]?>">
        <input type="hidden" name="pmoney" value="">
        <input type="hidden" id="tgurl" value="">
        <button type="submit" name="sub" id="sub" >我要购买</button>
    </div>
</form>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript">
    wx.config({
        appId: "<?php echo $wx['appId'];?>",
        timestamp: <?php echo $wx['timestamp'];?>,
        nonceStr: "<?php echo $wx['nonceStr'];?>",
        signature: "<?php echo $wx['signature'];?>",
        jsApiList: [
            'checkJsApi',
            'onMenuShareTimeline',
            'onMenuShareAppMessage',
            'onMenuShareQQ',
            'onMenuShareWeibo',
            'hideMenuItems',
            'showMenuItems',
            'hideAllNonBaseMenuItem',
            'showAllNonBaseMenuItem',
            'translateVoice',
            'startRecord',
            'stopRecord',
            'onRecordEnd',
            'playVoice',
            'pauseVoice',
            'stopVoice',
            'uploadVoice',
            'downloadVoice',
            'chooseImage',
            'previewImage',
            'uploadImage',
            'downloadImage',
            'getNetworkType',
            'openLocation',
            'getLocation',
            'hideOptionMenu',
            'showOptionMenu',
            'closeWindow',
            'scanQRCode',
            'chooseWXPay',
            'openProductSpecificView',
            'addCard',
            'chooseCard',
            'openCard'
        ]
    });
    wx.ready(function () {
        var shareData = {
            title: '<?php echo $row["title"];?>',
           
            //desc: '<?php echo trim(str_replace("\r","",str_replace("\n","",mb_substr(strip_tags($row["descrition"]),0,40,'utf-8'))));?>',
            desc: '<?php echo $row["shortdesc"];?>',
            link: "<?php echo $GETURL;?>detail.php?id=<?php echo $id; ?>&tjid=<?php echo $_SESSION[$PRE.'userid'];?>",
            imgUrl: '<?php echo "http://".$_SERVER['SERVER_NAME'].$row["pic"];?>',
        };
		
        var adurl="<?php echo $GETURL;?>index.php?id=<?php echo $id; ?>&tjid=<?php echo $_SESSION[$PRE.'userid'];?>";//回调
        //分享朋友
        wx.onMenuShareAppMessage({
            title: shareData.title,
            desc: shareData.desc,
            link: shareData.link,
            imgUrl:shareData.imgUrl,
            trigger: function (res) {
            },
            success: function (res) {
                window.location.href ="fx.php?bk=2&showfs=1&useid=<?php echo $_SESSION[$PRE.'userid'];?>";
            },
            cancel: function (res) {
            },
            fail: function (res) {
                alert(JSON.stringify(res));
            }
        });
        //朋友圈
        wx.onMenuShareTimeline({
            title: shareData.title+"---"+shareData.desc,
            link: shareData.link,
            imgUrl:shareData.imgUrl,
            trigger: function (res) {
            },
            success: function (res) {
                window.location.href ="fx.php?bk=2&showfs=2&useid=<?php echo $_SESSION[$PRE.'userid'];?>";
            },
            cancel: function (res) {
            },
            fail: function (res) {
                alert(JSON.stringify(res));
            }
        });

    });


    function share(){
        document.getElementById('share-wx').style.display = 'block';
        document.getElementById('share-wx').onclick = function(){
            this.style.display = 'none';
        };
    }

</script>
</body>
</html>