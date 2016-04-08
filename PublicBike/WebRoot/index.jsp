<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=CXGF8VHDNizi9pwgORctTfxg"></script>
	<script src="http://libs.baidu.com/jquery/1.9.0/jquery.js"></script>
	<script src="http://echarts.baidu.com/build/dist/echarts.js"></script>
	<title>自行车租借量</title>
	
  </head>
  
  <body>
  
    <div >
		<div id="allmap" style="float:left; height:400px; width: 60% ;"></div>
		
		<div style="float:right; height: 100%; width: 40%">
			<input style="margin-left: 120px; margin-top:120px" type="date" id="time" value="2014-03-23" min="2014-01-17"
				max="2014-06-23" onchange="changdate()" />
			<div id="main1" style="height: 400px; width: 100%"></div>
		</div>
		
		<div style="height:320px; width: 100%;">
			
			<div id="main"  style="height:100%; width: 60%; " ></div>
			<br/><font style="margin-left:320px; font-size: 22px;font-weight: bolder;color: '#333'">The long-term bicycle circulation view</font><br/>
			<font style="position: relative; margin-left:320px; font-size: 16px;font-weight: normal;color: 'black';font-family: sans-serif;">select time periods:</font>
			<input style="position: relative;" type="date" id="timefrom" value="2014-03-17" min="2014-01-17"
					max="2014-06-23" onchange="changmonth()" /> to
		   	<input style="position: relative;" type="date" id="timeto" value="2014-03-27" min="2014-01-17"
					max="2014-06-23" onchange="changmonth()" />
			
		</div>
		
	</div>
	<input type="hidden" id="station" />
	   
  </body>
</html>

<script type="text/javascript">
	<!-- 输入年月日，判读这天星期几 -->
		function isWeekend(year, mouth, day) {
			if(mouth==5&&day==4)
				return false;
			var dyear = year - 2008; //距离多少年
			var dday; //距离当年多少天
			var result = 0; //存储结果
			switch (mouth) {

			case 1:
				dday = day;
				break;

			case 2:
				dday = 31 + day;
				break;

			case 3:
				dday = 59 + day;
				break;

			case 4:
				dday = 90 + day;
				break;

			case 5:
				dday = 120 + day;
				break;

			case 6:
				dday = 151 + day;
				break;

			case 7:
				dday = 181 + day;
				break;

			case 8:
				dday = 212 + day;
				break;

			case 9:
				dday = 243 + day;
				break;

			case 10:
				dday = 273 + day;
				break;

			case 11:
				dday = 304 + day;
				break;

			case 12:
				dday = 334 + day;
				break;
			}
			if (dyear > 0) {
				result = dyear * 365 + dday + parseInt((dyear - 1) / 4) - 220;
				if (dyear % 4 == 0 && mouth > 2)
					result++;
			} else if (dyear == 0) {
				result = dday - 221;
				if (mouth > 2)
					result++;
				if (result < 0)
					result = -result;
			} else {
				dyear = -dyear;
				result = dyear * 365 - dday + parseInt(dyear / 4) + 221;
				if (mouth > 2 && dyear % 4 == 0)
					result--;
			}
			result = (result % 7 + 5) % 7;
			if (result == 6 || result == 0) {
				return true;
			} else {
				return false;
			}
		}

		function isHoliday(mouth,day) {
			if(mouth==1 && day==31)
				return true;
			
			if(mouth==2 && day<=6 )
				return true;
			
			if(mouth==4 && day>=5 && day<=7)
				return true;
			
			if(mouth==5 &&((day>=1 && day<=3)||(day==31)))
				return true;
		
			if(mouth==6 && day>=1 && day<=2)
				return true;
			return false;
		}
	</script>

<!-- 加载折线图 -->
	<script type="text/javascript">
		// 路径配置
        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });
		require([ 'echarts', 'echarts/chart/line', 'echarts/chart/bar',],
				DrawCharts //回调函数
		);
		var myChart;
		var myChart1;
		function DrawCharts(ec){
			//基于准备好的dom，初始化echarts图表
			myChart = ec.init(document.getElementById('main'), 'macarons');
			myChart1 = ec.init(document.getElementById('main1'), 'macarons');
		}
		
		function initChart1(HOUR, leasenum){
			var option = {
					title : {
						text : 'Station name:' + stationinfo.stationname   ,
							y:32,
						textStyle:{
							fontSize:16,
							fontWeight:'normal',
							color:'black',
							fontFamily:'sans-serif'
						}
					},
					tooltip : {        //气泡提示框，常用于展现更详细的数据
				        trigger: 'axis'
				    },
				    legend: {         //图例，表述数据和图形的关联
				        data:['rental number']
				    },
				    toolbox: {       //辅助工具箱，辅助功能，如添加标线，框选缩放等
				        show : true,
				        feature : {
				            mark : {show: true},
				            dataView : {show: true, readOnly: false},
				            magicType : {show: true, type: ['line', 'bar']},
				            restore : {show: true},
				            saveAsImage : {show: true}
				        }
				    },
				    calculable : true,
				    xAxis : [
				        {
				            type : 'category',
				            boundaryGap : false,
				            data : HOUR
				        }
				    ],
				    yAxis : [
				        {
				            type : 'value',
				            axisLabel : {
				                formatter: '{value}'
				            }
				        }
				    ],
				    series : [  //数据系列，一个图表可能包含多个系列，每一个系列可能包含多个数据
				        {
				            name:'rental number',
				            type:'line',
				            data:leasenum,
				            markPoint : {
				                data : [
				                    {type : 'max', name: '最大值'},
				                    {type : 'min', name: '最小值'}
				                ]
				            },
				            markLine : {
				                data : [
				                    {type : 'average', name: '平均值'}
				                ]
				            }
				        }
				    ]
                };
                // 为echarts对象加载数据 
                myChart1.setOption(option);
                //myChart1.hideLoading();
		}
		
		function initChart(date, leasenum) {
			
			var option = {
				title : {
					text : 'Station name:' + stationinfo.stationname   
							+ '\n                                       The selected rental and return time：' + timefrom.value
							+ '~' + timeto.value,
						y:32,
					textStyle:{
						fontSize:16,
						fontWeight:'normal',
						color:'black',
						fontFamily:'sans-serif'
					}
				},
				tooltip : {
					trigger : 'axis'
				},
				legend : {
					show : true,
					y:75,
					data : [ 'rental number']
				},
				calculable : true,
				grid : {     //直角坐标系中除坐标轴外的绘图网格，用于定义直角系整体布局
					width:'85%',
					height:'60%',
					x:'5%',
					y:'33%'
				},
				xAxis : [ {
					type : 'category',
					boundaryGap : false,
					axisLine : {
						onZero : false
					},
					splitLine : {
						lineStyle : {
							type : 'dashed',
							color : [ 'red']
						}
					},
					name : 'Date of rental bike',
					nameTextStyle:{
						fontSize:5
					},
					axisLabel : {
						interval : 0,
						clickable : true,
					},
					data :date
				} ],
				yAxis : [ {
					name : ' Number of rental bike ',
					
					type : 'value',
					boundaryGap : [ 0.01, 0.01 ],
					splitLine : {
						lineStyle : {
							type : 'dashed',
							color : [ 'white' ]
						}
					},
					scale : true
				} ],
				series : [ {
					name : 'rental number',
					type : 'bar',
					data : leasenum,
					smooth : true,
					stack : '总量',
					itemStyle : {
						normal : {
							areaStyle : {
								type : 'default'
							}
						}
					},
					symbolSize : 3,
					showAllSymbol : true,
					markPoint : {
						data : [ {
							type : 'max',
							name : '最大值'
						}, {
							type : 'min',
							name : '最小值'
						} ]
					}
				}]
			};
			myChart.setOption(option);
			//myChart.hideLoading();
		}
	</script>
	
	<script type="text/javascript">
		var http_request;
		var stationinfo = 0;
		var timefrom = document.getElementById("timefrom");
		var timeto = document.getElementById("timeto");
		var time = document.getElementById("time");
		var fromMonth;
		var toMonth;
		var fromDay;
		var toDay;
		function sendRequest(data) {
			stationinfo = data;
			if (window.ActiveXObject) {   //判断浏览器是否支持ActiveX控件
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} else {
				http_request = new XMLHttpRequest();
			}
			if (http_request) {
				//parseInt() 函数可解析一个字符串，并返回一个整数
				fromMonth=parseInt(timefrom.value.split("-")[1]);   //split() 方法用于把一个字符串分割成字符串数组
				fromDay =parseInt(timefrom.value.split("-")[2]);    //按照字符"-",自动将字符串分成几个部分
				toMonth=parseInt(timeto.value.split("-")[1]);
				toDay =parseInt(timeto.value.split("-")[2]);
				var url = "http://localhost:8080/WebTest/Data.html?stationid="
						+ data.stationid + "&from=" + timefrom.value + "&to="
						+ timeto.value;
				http_request.open("GET", url, true);
				//open()方法第一个参数定义发送请求所使用的方法,第二个参数规定服务器端脚本的URL，第三个参数规定应当对请求进行异步地处理
				http_request.onreadystatechange = chuli;  //onreadystatechange 属性存有处理服务器响应的函数（chuli）
				http_request.send();  //send() 方法将请求送往服务器
			}
		}
		//处理函数
		function chuli() {
			if (http_request.readyState == 4) {     //readyState 属性存有服务器响应的状态信息  4 表示请求已完成
				if (http_request.status == 200) {   //判断服务器是否成功接收客户请求
					var res = http_request.responseText;//responseText属性用于取回服务器返回的数据
					var lease_info = res.split("@wujiu@")[0];
					console.log(lease_info);
					lease_info = eval("(" + lease_info + ")");  //eval() 函数可计算某个字符串，并执行其中的的 JavaScript 代码
					myChart.clear();

					if (lease_info.length == 0) {
						alert("数据库中没有关于站点：" + stationinfo.stationname + "的相关数据");
						myChart.hideLoading();
						return;
					}
					var DateList = [];
					var leasenum = [];
					var length_lease=0;
					var monthLease=parseInt(lease_info[length_lease].leasedate.split('-')[1]);
					var dayLease=parseInt(lease_info[length_lease].leasedate.split('-')[2]);
					console.log(dayLease);
					var day;
					for(var i=fromMonth;i<=toMonth;i++)
					{
						var len;
						if(i==toMonth)
							len=toDay;
						else if(i==2)
							len=28;
						else if(i==1||i==3||i==5)
							len =31;
						else
							len =30;
						for(var j=fromDay;j<=len;j++)
						{
							if(j==fromDay)
								day=i+'-'+j;
							else
								day=j;
							
							if (isHoliday(i,j))
							{
								DateList.push({
									value : day,
									textStyle : {color : 'red',fontWeight : 'bold'}
								});
							} 
							else if (isWeekend(2014,i,j))
							{
								DateList.push({
									value : day,
									textStyle : {color : 'green',fontWeight : 'bold'}
								});
							} 
							else {
								DateList.push({
									value : day,
									textStyle : {color : 'black',fontWeight : 'bold'}
								});
							}
							if(lease_info.length>length_lease && i==monthLease && j==dayLease)
							{
								leasenum.push(parseInt(lease_info[length_lease].leasenum));
								length_lease++;
								if(lease_info.length>length_lease)
								{
									monthLease=parseInt(lease_info[length_lease].leasedate.split('-')[1]);
									dayLease=parseInt(lease_info[length_lease].leasedate.split('-')[2]);
								}
								
							}else
								leasenum.push('-');
						}
						fromDay=1;
					}
					initChart(DateList, leasenum);
				} else {
					myChart.hideLoading();
					alert("请换一个浏览器试试");
				}
			}
		}

		function changemonth() {
			if(timefrom.value > timeto.value){
				return;
			}
			if (stationinfo != 0 ) {
				sendRequest(stationinfo);
			} else {
				alert("请先在地图上选择一个你要查询的点！");
			}
		}
	</script>
	
	<!-- 画表二 -->
	<script type="text/javascript">
		var http_request1;
		var time = document.getElementById("time");
		function sendRequest1(data) {
			if (window.ActiveXObject) {
				http_request1 = new ActiveXObject("Microsoft.XMLHTTP");
			} else {
				http_request1 = new XMLHttpRequest();
			}
			if (http_request1) {

				var url = "http://localhost:8080/WebTest/DatabyHour.html?stationid="
						+ data.stationid + "&time=" + time.value;
				http_request1.open("GET", url, true);
				http_request1.onreadystatechange = chuli1;
				http_request1.send();
			}
		}

		//处理函数
		function chuli1() {
			if (http_request1.readyState == 4) {
				if (http_request1.status == 200) {
					var res = http_request1.responseText;
					var lease_info = res.split("@wujiu@")[0];
					lease_info = eval("(" + lease_info + ")");
					myChart1.clear();
					if (lease_info.length == 0) {
						alert("没有获取到数据！！");
						myChart1.hideLoading();
						return;
					}
					var HOUR = [];
					var leasenum = [];
					for(var i=0;i<24;i++){
						leasenum[i]=0;
						HOUR.push(i);
					}
					var num;
					for (var i = 0; i < lease_info.length; i++) {
						var hour=parseInt(lease_info[i].hour);
						num=parseInt(lease_info[i].leasenum);
						leasenum[hour]=num;
						leasenum.push(leasenum[hour]);
					}
					initChart1(HOUR, leasenum);
				} else {
					myChart1.hideLoading();
					alert("请换一个浏览器试试");
				}
			}
		}

		function changdate() {
			if (stationinfo != 0) {
				sendRequest1(stationinfo);
			} else {
				alert("请先在地图上选择一个你要查询的点！");
			}
		}
	</script>
	
<script type="text/javascript">
	// 百度地图API功能	
	var map = new BMap.Map("allmap");
	map.centerAndZoom(new BMap.Point(120.202832,30.248621), 15);    //120.202832,30.248621
	var stations = ${station};  
	for (var i = 0; i < stations.length; i++) {
		createMarker(stations[i]);
    }
    //坐标转换完之后的回调函数
    function createMarker(data){
    	var point = new BMap.Point(data.lng,data.lat);
    	translateCallback = function(demo) {
     		if(demo.status === 0) {
            	var marker = new BMap.Marker(demo.points[0]);
            	marker.addEventListener("click", function() {
            		map.openInfoWindow(new BMap.InfoWindow("站点信息: "+
            											   "<br/>Station Name: "+data.stationname+
            											   "<br/>Station Id: "+data.stationid+
            											   "<br/>Lng&Lat: "+data.lng.toFixed(5)+" , "+data.lat.toFixed(5),{offset:new BMap.Size(0,-20)}),demo.points[0]);
            	    //myChart.showLoading();
            	    //myChart1.showLoading();
            		sendRequest(data);
            		sendRequest1(data);
            	});
            	map.addOverlay(marker);
        	}
    	}
        var convertor = new BMap.Convertor();
        var pointArr = [];
        pointArr.push(point);
        convertor.translate(pointArr, 1, 5, translateCallback);
    }
</script>
