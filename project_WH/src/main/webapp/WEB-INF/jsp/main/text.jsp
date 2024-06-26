<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지도</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
	integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
	integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
	crossorigin="anonymous"></script>

	
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	google.charts.load("current", {packages:['bar']});
	
	function drawChart(result) {
		
		$('#bardiv').show();
		
		let rows =[];
		
		result.forEach(function(i){
			let arr = new Array();
			arr.push(i.nm);
			arr.push(i.amount);
			rows.push(arr);
		})
		
		var data = new google.visualization.DataTable();
		data.addColumn('string');
        data.addColumn('number', '전기');
        data.addRows(rows);

   var options = {
      	legend: {
      	     position: 'none'
      	   },
        bars: 'horizontal', // Required for Material Bar Charts.
        width: '90%',
        height: '90%'
      };

      var chart = new google.charts.Bar(document.getElementById('bar'));

		chart.draw(data, options);
	}
	
	$(function() {

		$("#uploaddiv").hide();
		$("#chartdiv").hide();
		
		$("#tanso").on("click",function(){
			$("#uploaddiv").hide();
			$("#chartdiv").hide();

			let upload = document.querySelector('#data');
			let chart = document.querySelector('#statics');
			let select = document.querySelector('#tanso');
			
 			upload.classList.remove('active');
 			chart.classList.remove('active');
 			select.classList.add('active');

			$("#selectdiv").show();
		})
		
		$("#data").on("click",function(){
			$("#selectdiv").hide();
			$("#chartdiv").hide();
			
			let upload = document.querySelector('#data');
			let chart = document.querySelector('#statics');
			let select = document.querySelector('#tanso');
			
			select.classList.remove('active');
 			chart.classList.remove('active');
 			upload.classList.add('active');
			
			$("#uploaddiv").show();
		})
		
		$("#statics").on("click",function(){
			$("#selectdiv").hide();
			$("#uploaddiv").hide();
			
			let upload = document.querySelector('#data');
			let chart = document.querySelector('#statics');
			let select = document.querySelector('#tanso');
			
 			upload.classList.remove('active');
 			select.classList.remove('active');
 			
 			chart.classList.add('active');
			
			$("#chartdiv").show();
		})
		
		var sd, sgg, bjd,legendDiv;
		
		
		
		let Base = new ol.layer.Tile(
				{
					name : "Base",
					source : new ol.source.XYZ(
							{
								url : 'https://api.vworld.kr/req/wmts/1.0.0/11A86578-3FCE-3AEC-AAE8-E98D79D01E9C/Base/{z}/{y}/{x}.png'
							})
				}); // WMTS API 사용

		let olview = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
			center : ol.proj.transform([ 126.970371, 37.554376 ], 'EPSG:4326',
					'EPSG:3857'),
			zoom : 15
		});

		let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
			target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
			layers : [ Base ],// 지도에서 사용 할 레이어의 목록을 정희하는 공간이다
			view : olview
		});
		
		
		
		
		//맵 클릭 이벤트
		map.on('singleclick', async function(evt) {
		    var coordinate = evt.coordinate;
		    var hdms = coordinate;
		    
			const wmsLayer = map.getLayers().getArray().filter(layer=>layer.get('name')==='legend')[0];
			const source = wmsLayer.getSource();
			
			const url = source.getFeatureInfoUrl(coordinate,map.getView().getResolution(),'EPSG:3857',{
				QUERY_LAYERS: 'seonwoo:d1bjdview',
				INFO_FORMAT: 'application/json'
			});
			
			// GetFeatureInfo URL이 유효할 경우
			if (url)
			{
				const request = await fetch(url.toString(), { method: 'GET' }).catch(e => alert(e.message));

				// 응답이 유효할 경우
				if (request)
				{
					// 응답이 정상일 경우
					if (request.ok)
					{
						const json = await request.json();
						
						
						// 객체가 하나도 없을 경우
						if (json.features.length === 0)
						{
							overlay.setPosition(undefined);
						}

						// 객체가 있을 경우
						else
						{
							// GeoJSON에서 Feature를 생성
							const feature = new ol.format.GeoJSON().readFeature(json.features[0]);

							// 생성한 Feature로 VectorSource 생성
							const vector = new ol.source.Vector({ features: [ feature ] });
							
							// 툴팁 DIV 생성
						    let element = document.createElement("div");
						    element.classList.add('ol-popup');
						    element.innerHTML = '<a id="popup-closer" class="ol-popup-closer"></a> <div><span>'+feature.get('bjd_nm')+'</span><hr><code>'+feature.get('totalusage').toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')+'</code></div>';
						    element.style.display = 'block';

							// OverLay 생성
						    let overlay = new ol.Overlay({
						        element: element, // 생성한 DIV
						        autoPan: true,
						        className: "multiPopup",
						        autoPanMargin: 100,
						        autoPanAnimation: {
						            duration: 400
						        }
						    });
							//오버레이의 위치 저장
						    overlay.setPosition(coordinate);
						    //지도에 추가
						    map.addOverlay(overlay);

							// 해당 DIV 다켓방법
						    let oElem = overlay.getElement();
						    oElem.addEventListener('click', function(e) {
						        var target = e.target;
						        if (target.className == "ol-popup-closer") {
						            //선택한 OverLayer 삭제
						            map.removeOverlay(overlay);

						        }
						    });
						}
					}

					// 아닐 경우
					else
					{
						alert(request.status);
					}
				}
			}
		});
		

		$("#sdselect").on("change",function() {
					if(legendDiv != null){
						legendDiv.remove();					
					}
					var test = $("#sdselect option:checked").text();

					$.ajax({
						url : "/selectSgg.do",
						type : "post",
						dataType : "json",
						data : {
							"test" : test
						},
						success : function(result) {

							map.removeLayer(sd);
							map.removeLayer(sgg);
							map.removeLayer(bjd);	
							
							var list = result.list;
							var geom = result.geom;
							
							$("#sgg").empty();
							var sgg = "<option>시군구 선택</option>";

							for (var i = 0; i < list.length; i++) {
								sgg += "<option value='"+list[i].sgg_cd+"'>"
										+ list[i].sgg_nm + "</option>"
							}

							$("#sgg").append(sgg);
							
							map.getView().fit([geom[0].xmin, geom[0].ymin, geom[0].xmax, geom[0].ymax],{
								duration:900
							});

							map.removeLayer(sd);
							var sd_CQL1 = "sd_cd=" + $("#sdselect").val();
							
							var sdSource = new ol.source.TileWMS(
									{
										url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
										params : {
											'VERSION' : '1.1.0', // 2. 버전
											'LAYERS' : 'cite:tl_sd', // 3. 작업공간:레이어 명
											'CQL_FILTER' : sd_CQL1,
											'BBOX' : [ 1.3871489341071218E7,
													3910407.083927817,
													1.4680011171788167E7,
													4666488.829376997 ],
											'SRS' : 'EPSG:3857', // SRID
											'FORMAT' : 'image/png', // 포맷
											'TRANSPARENT' : 'TRUE',

										},
										serverType : 'geoserver',
									});

							sd = new ol.layer.Tile({
								source : sdSource,
								opacity : 0.2
							});

							map.addLayer(sd);
						},
						error : function() {
							alert("실패");
						}
					})
				});

		
		$("#sgg").on("change",function() {
			if(legendDiv != null){
				legendDiv.remove();					
			}
			var sggno = $("#sgg option:checked").val();
			var sggnm = $("#sgg option:checked").text();
			
			$.ajax({
				url : "/selectbjd.do",
				type : "post",
				dataType : "json",
				data : {  
					"sggno" : sggno,
					"sggnm" :sggnm
				},
				success : function(result) {
					
					var geom = result.geom;
					map.getView().fit([geom[0].xmin, geom[0].ymin, geom[0].xmax, geom[0].ymax],{
						duration:900
					});

					map.removeLayer(sgg);
					map.removeLayer(bjd);

					var sgg_CQL1 = "sgg_cd=" + $("#sgg option:checked").val();
					
					//map.addLayer(sgg); // 맵 객체에 레이어를 추가함

					bjd = new ol.layer.Tile(
							{
								source : new ol.source.TileWMS(
										{
											url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
											params : {
												'VERSION' : '1.1.0', // 2. 버전
												'LAYERS' : 'cite:tl_bjd', // 3. 작업공간:레이어 명
												'CQL_FILTER' : sgg_CQL1,
												'BBOX' : [ 1.3873946E7,
														3906626.5,
														1.4428045E7,
														4670269.5 ],
												'SRS' : 'EPSG:3857', // SRID
												'FORMAT' : 'image/png', // 포맷
											},
											serverType : 'geoserver',
										}),
								opacity : 0.8
							});
					
					sgg = new ol.layer.Tile(
							{
								source : new ol.source.TileWMS(
										{
											url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
											params : {
												'VERSION' : '1.1.0', // 2. 버전
												'LAYERS' : 'cite:tl_sgg', // 3. 작업공간:레이어 명
												'CQL_FILTER' : sgg_CQL1,
												'BBOX' : [ 1.3873946E7,
														3906626.5,
														1.4428045E7,
														4670269.5 ],
												'SRS' : 'EPSG:3857', // SRID
												'FORMAT' : 'image/png', // 포맷
											},
											serverType : 'geoserver',
										}),
								opacity : 0.8
							});

					//map.addLayer(bjd); // 맵 객체에 레이어를 추가함

					map.addLayer(sgg);
					map.addLayer(bjd);
					
				},
				error : function() {
					alert("실패");
				}
			})
		});
		
		
		$(".insertbtn").click(function() {
			let legend = $('#legend option:checked').val();
			let sggno = $("#sgg option:checked").val();
			
			$.ajax({
				url:"/legend.do",
				data:{"legend":legend,"sggno":sggno},
				type:"post",
				dataType:"json",
				success:function(result){
					if(legend == 1){
						if(legendDiv != null){
							legendDiv.remove();							
						}
						map.removeLayer(bjd);
						map.removeLayer(sgg);
						let sgg_CQL1 = "sgg_cd="+$("#sgg option:checked").val();
						
						
						bjd = new ol.layer.Tile(
								{
									properties: { name: 'legend' },
									source : new ol.source.TileWMS(
											{
												url : 'http://localhost/geoserver/seonwoo/wms?service=WMS', // 1. 레이어 URL
												params : {
													'VERSION' : '1.1.0', // 2. 버전
													'LAYERS' : 'seonwoo:d1bjdview', // 3. 작업공간:레이어 명
													'CQL_FILTER' : sgg_CQL1,
													'BBOX' : [ 1.3873946E7,
															3906626.5,
															1.4428045E7,
															4670269.5 ],
													'SRS' : 'EPSG:3857', // SRID
													'FORMAT' : 'image/png', // 포맷
													'STYLES':'interval'
													
												},
												serverType : 'geoserver',
											}),
									opacity : 0.8
								});
						
						map.addLayer(bjd);
						
						let legendValue = result.legend;
						
	
						legendDiv = document.createElement("div");
						
						legendDiv.setAttribute("style","text-align:center;position: absolute;background-color:white;z-index:10;position:absolute;right:10px;bottom:10px");
						legendDiv.setAttribute("id","legend");
						
						$("#map").append(legendDiv);
						
						let legendTable = document.createElement("table");
						legendTable.setAttribute("id","legendTable");
						
						legendDiv.appendChild(legendTable);
						

						let legendHeadTr = document.createElement("tr");
						let legendHead = document.createElement("td");
						let legendBody = document.createElement("tbody");
						

						legendTable.appendChild(legendHeadTr);
						legendHeadTr.appendChild(legendHead);

						legendHead.setAttribute("colspan","2");
						legendHead.setAttribute("style","font-size:24px;font-weight: bold;");
						legendHead.innerText="범 례";
						
						legendTable.appendChild(legendBody);
						
						
						for(let i = 0; i<legendValue.length;i++){
							
							let legendTr = document.createElement("tr");
			
							legendBody.appendChild(legendTr);
							
							let legendTd1 = document.createElement("td");
							let legendTd2 = document.createElement("td");

							legendTr.appendChild(legendTd1);
							legendTr.appendChild(legendTd2);
							
							legendTd1.innerHTML="<img style='background-size:100%' src='/resource/img/"+i+".png'>"
							legendTd2.innerText= legendValue[i].from_val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') +" ~ "+legendValue[i].to_val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
						}
						
						
						
					}else if(legend==2){
						if(legendDiv != null){
							legendDiv.remove();							
						}
						map.removeLayer(bjd);
						map.removeLayer(sgg);

						let sgg_CQL1 = "sgg_cd="+$("#sgg option:checked").val();
						
						
						bjd = new ol.layer.Tile(
								{
									properties: { name: 'legend' },
									source : new ol.source.TileWMS(
											{
												url : 'http://localhost/geoserver/seonwoo/wms?service=WMS', // 1. 레이어 URL
												params : {
													'VERSION' : '1.1.0', // 2. 버전
													'LAYERS' : 'seonwoo:d1bjdview', // 3. 작업공간:레이어 명
													'CQL_FILTER' : sgg_CQL1,
													//'viewparams' : ''
													'BBOX' : [ 1.3873946E7,
															3906626.5,
															1.4428045E7,
															4670269.5 ],
													'SRS' : 'EPSG:3857', // SRID
													'FORMAT' : 'image/png', // 포맷
													'STYLES':'natural'
												},
												serverType : 'geoserver',
											}),
									opacity : 0.8
								});
						
						map.addLayer(bjd);
						
						let legendValue = result.legend;
						
						
						legendDiv = document.createElement("div");
						
						legendDiv.setAttribute("style","text-align:center;position: absolute;background-color:white;z-index:10;position:absolute;right:10px;bottom:10px");
						legendDiv.setAttribute("id","legend");
						
						$("#map").append(legendDiv);
						
						let legendTable = document.createElement("table");
						legendTable.setAttribute("id","legendTable");
						
						legendDiv.appendChild(legendTable);
						

						let legendHeadTr = document.createElement("tr");
						let legendHead = document.createElement("td");
						let legendBody = document.createElement("tbody");
						

						legendTable.appendChild(legendHeadTr);
						legendHeadTr.appendChild(legendHead);

						legendHead.setAttribute("colspan","2");
						legendHead.setAttribute("style","font-size:24px;font-weight: bold;");
						legendHead.innerText="범 례";
						
						legendTable.appendChild(legendBody);
						
						
						for(let i = 0; i<legendValue.length;i++){
							
							let legendTr = document.createElement("tr");
			
							legendBody.appendChild(legendTr);
							
							let legendTd1 = document.createElement("td");
							let legendTd2 = document.createElement("td");

							legendTr.appendChild(legendTd1);
							legendTr.appendChild(legendTd2);
							
							legendTd1.innerHTML="<img style='background-size:100%' src='/resource/img/"+i+".png'>"
							legendTd2.innerText= legendValue[i].from_val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') +" ~ "+legendValue[i].to_val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
						}
					}
				},
				error:function(){
					
				}
			})
		});
		
		
		
		$("body").on("click",function(){
			$("#bardiv").hide();
			$(".container").next().remove();
		})
		
		$("#transdb").on("click", function() {
			var test = $("#txtfile").val().split(".").pop();

			var formData = new FormData();
			formData.append("testfile", $("#txtfile")[0].files[0]);

			if ($.inArray(test, [ 'txt' ]) == -1) {
				alert("pem 파일만 업로드 할 수 있습니다.");
				$("#txtfile").val("");
				return false;
			}

			$.ajax({
				url : "/fileUpload.do",
				type : 'post',
				enctype : 'multipart/form-data',
				//contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				data : formData,
				contentType : false,
				processData : false,
				beforeSend : function() {
					modal();
				},
				success : function() {
					$('#uploadtext').text("업로드 완료");
					setTimeout(timeout, 5000);
				}
			})

		})
		
		
		$("#charttbtn").on("click",function(){

			let sdCharcd = $("#sdChartSelect option:checked").val();
			
			$.ajax({
				url:'/chart.do',
				type:'post',
				data:{'sdcd':sdCharcd},
				dataType:'json',
				success:function(result){
					drawChart(result);
				},
				error:function(){
					alert("실패");
				}
			});

			
		});
		
		
		
		
		
	});
	
	

		
	
	
	
	var timeout = function() {
		$('#mask').remove();
		$('#loading').remove();

	}
	
	function modal() {
		var maskHeight = $(document).height();
		var maskWidth = window.document.body.clientWidth;

		var mask = "<div id='mask' style='position:absolute;z-indx:5;background-color: rgba(0, 0, 0, 0.13);display:none;left:0;top:0;'></div>";
		var loading = "<div id='loading' style='background-color:white;width:500px'><h1 id='uploadtext' style='text-align:center'>업로드 진행중</h1></div>";

		$('body').append(mask);
		$('#mask').append(loading);

		$("#mask").css({
			'height' : maskHeight,
			'width' : maskWidth
		});

		$('#loading').css({
			/* 'position': 'absolute',
			'top': '50%',
			'left': '50%',
			'transform': 'translate(-50%, -50%)' */
			'position' : 'absolute',
			'left' : '800px',
			'top' : '100px'

		})
		$('#mask').show();
		$('#loading').show();
		
	}
	
	
		
</script>
<style>
.ol-popup {
        position: absolute;
        background-color: white;
        box-shadow: 0 1px 4px rgba(0,0,0,0.2);
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #cccccc;
        bottom: 12px;
        left: -50px;
        min-width: 280px;
      }
      .ol-popup:after, .ol-popup:before {
        top: 100%;
        border: solid transparent;
        content: " ";
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
      }
      .ol-popup:after {
        border-top-color: white;
        border-width: 10px;
        left: 48px;
        margin-left: -10px;
      }
      .ol-popup:before {
        border-top-color: #cccccc;
        border-width: 11px;
        left: 48px;
        margin-left: -11px;
      }
      .ol-popup-closer {
        text-decoration: none;
        position: absolute;
        top: 2px;
        right: 8px;
      }
      .ol-popup-closer:after {
        content: "✖";
      }
</style>
<style type="text/css">
body {
	margin: 0px;
	padding: 0px;
	width: 100vw;
	height: 100vh;
}

.container {
	margin: 0 auto;
	width: 100%;
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.main {
	width: 80%;
	height: 80%;
	display: flex;
	border-top: 1px solid #BDBDBD;
	border-left: 1px solid #BDBDBD;
}

.btncon {
	width: 30%;
}

.map {
	width: 70%;
	position: relative;
}

.footer {
	height: 10%;
	display: flex;
	justify-content: center;
	align-items: center;
	border-bottom: 1px solid #BDBDBD;
}

.menu {
	height: 90%;
	display: flex;
}

.menubar {
	width: 30%;
	display: inline-block;
	border-right: 1px solid #BDBDBD;
}

.menubar > button{
	padding: 8px 4px;
	text-align:center;    
	border-left: none;
    border-right: none;
}

.list-group-item:first-child{
	border-top-left-radius:unset;
	border-top-right-radius:unset;
}



.func {
	padding:10px;
	width: 70%;
	text-align: center;
}
.func > select{
	width:100%;
	height: 25px;
	margin-bottom: 10px;
	font-weight: bold;
	color:#585858;
}
.main > div {
	border-right: 1px solid #BDBDBD;
	border-bottom: 1px solid #BDBDBD;
}

.insertbtn{
	width:100%;
}

table, th, td {
  border: 1px solid #E6E6E6;
  border-collapse: collapse;
  
}

tbody > tr > td:nth-child(2) {
	padding:5px;
}
tbody > tr > td:nth-child(1) {
	padding:0px;
}

tbody > tr > td > img {
	width: 32px;
	height:32px;
}

#selectdiv > select {
	width:100%;
	margin-bottom: 8px;
}

#sdChartSelect{
	width:100%;
	margin-bottom: 10px;
}

#transdb, #charttbtn{
	width:100%;
}
</style>
</head>
<body>
	<div class="container">
		<div class="main">
			<div class="btncon">
				<div class="footer">
					<h3>탄소공간지도 시스템</h3>
				</div>
				<div class="menu">
					<div class="menubar list-group">
						<button id="tanso" class="list-group-item list-group-item-action active">탄소지도</button>
						<button id="data" class="list-group-item list-group-item-action">데이터삽입</button>
						<button id="statics" class="list-group-item list-group-item-action">통계</button>
					</div>

					<div class="func">
						<div id="selectdiv">
							<select id="sdselect">
								<option>시도 선택</option>
								<c:forEach items="${sdlist }" var="sd">
	
									<option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
								</c:forEach>
							</select> <select id="sgg">
								<option>시군구 선택</option>
							</select> <select id="legend">
								<option>범례 선택</option>
								<option value="1">등간격</option>
								<option value="2">Natural Break</option>
							</select>
	
							<button class="insertbtn">입력하기</button>
						
						</div>
						<div id="uploaddiv">
							<form id="uploadForm">
								<div class="input-group mb-3">
									<input class="form-control" type="file" accept=".txt" id="txtfile" name="txtfile">
								</div>
							</form>
							<button id="transdb">전송하기</button>					
						</div>
						<div id="chartdiv">
							<select id="sdChartSelect">
								<option class="sd" value="0">시도 전체</option>
								<c:forEach items="${sdlist }" var="sd">
									<option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
								</c:forEach>
							</select>
							
							<button id="charttbtn">검색</button>
						
						</div>
					</div>
				</div>
			</div>
			<div class="map" id="map">
				<div id="bardiv">
					<div id="bar" style="width: 90%; height: 90%;opacity:none;text-align: center"></div>
				
				</div>
			</div>

		</div>
	</div>
</body>
</html>
































