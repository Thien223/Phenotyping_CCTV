
/**
* 챠트 그리기
* 
* 호출하는곳 : EAC010.xml, EAA010.xml
*/
function chartDraw(chartContainerId, dataList, dataMap) {

	//
	// 공통 옵션
	//
	var chartOption = {
		animationEnabled: true,
		zoomEnabled: true,
		title: {text: ""},
		options: { plugins: { legend: { labels: { font: { size: 10 } } } } },		
		toolTip:{
			shared:	true,	//세로 데이터 한번에 보는 기능
			borderColor: 'silver',
			contentFormatter: function( e ) {
				/*	[id="xData"] : 세로 라인 표시	*/
				let content = '';
				if (e.entries) {
					content += '<b>[' + ( e.entries[0].dataPoint.x ).toFormatString('yyyy-mm-dd hh24:mi') + ']</b><br />';
					content = e.entries.reduce( (accumulator, currentValue, currentIndex, array) => {
						let yPointHTML = currentValue.dataPoint.y;
						//let $sChkArr = $('input[type="checkbox"][id^="sensorFilter"]');
						//let seqChecked = $sChkArr.eq( currentIndex ).prop('checked') || false;
						//if (seqChecked){
							return	accumulator
								+	'<div style="font-weight: bold;color: ' + currentValue.dataSeries.color + ';" >'
								+	currentValue.dataSeries.name
								+	' : '
								+	(yPointHTML === '--' ? '<span style="color: black;">' + yPointHTML + '</span>' : yPointHTML)
								+	'</div>';
						//}else{
						//	return accumulator;
						//}
					}, content);
					content += '<div id="xData" style="display:none;">' + ( e.entries[0].dataPoint.x ).toFormatString('yyyy-mm-dd hh24:mi') + '</div>';
				}
				return content;
			},
		},
		axisY : [ {
			title: (window.i18n?.[ 'dic.141' ] ?? '온도') + '/' + (window.i18n[ 'dic.175' ] ?? '이슬점'),
			titleFontSize: 12,
			titleFontColor:'#ff0000',
			labelFontSize: 10,
			labelFontColor: '#ff0000',
			includeZero:false,
			gridThickness: 0,
		    tickLength: 0,
		    lineThickness: 1,
		    lineColor: "#ff0000",
		}, {
			title: (window.i18n[ 'dic.183' ] ?? '일사량'),
			titleFontSize: 12,
			titleFontColor:'#F39D64',
			labelFontSize: 10,
			labelFontColor: '#F39D64',
			includeZero:false,
			gridThickness: 0,
		    tickLength: 0,
		    lineThickness: 1,
		    lineColor: "#F39D64",
		    maximum: 600,
		    minimum: 0
		} ],
		axisY2: [ {
			title: (window.i18n[ 'dic.113' ] ?? '습도'),
			titleFontSize: 12,
			titleFontColor:'#008000',
			labelFontSize: 10,
			labelFontColor: '#008000',
			includeZero:false,
			gridThickness: 0,
		    tickLength: 0,
		    lineThickness: 1,
		    lineColor: "#008000",
		    maximum: 90,
		    minimum: 10
		}, {
			title: (window.i18n[ 'dic.102' ] ?? '수분부족분'),
			titleFontSize: 12,
			titleFontColor:'#A99B9B',
			labelFontSize: 10,
			labelFontColor: '#A99B9B',
			includeZero:false,
			gridThickness: 0,
		    tickLength: 0,
		    lineThickness: 1,
		    lineColor: "#A99B9B"
		} ],
		axisX: {
			crosshair: {enabled: true },	// 세로 라인 표시
			labelFontSize: 10,
			valueFormatString: "YYYY-MM-DD HH:mm:ss",
		},
		data: undefined
	};

	
	//
	// 라인 각각 초기설정
	//
	let chartData = [];
	for (var i = 0; i < 10; ++i) {
		var series = {
			type: "line",
			name: "",
			visible: true,
			showInLegend: false,
			legendText: "",
			xValueFormatString: "YYYY-MM-DD HH:mm",
			dataPoints: []
		};
				
		switch (i) {
		case 0:
			series.name = "대기온도";
			series.visible = dataMap.get('temp');
			series.axisYIndex = 0;
			series.color = "red";
			break;
		case 1:
			series.name = "대기습도";
			series.visible = dataMap.get('humi');
			series.axisYIndex = 0;
			series.axisYType = "secondary";
			series.color = "green";
			break;
		case 2:
			series.name = "이슬점";
			series.visible = dataMap.get('dewPoint');
			series.axisYIndex = 0;
			series.color = "#66A9F5";
			break;
		case 3:
			series.name = "수분부족";
			series.visible = dataMap.get('lackMoisture');
			series.axisYIndex = 1;
			series.axisYType = "secondary";
			series.color = "#A99B9B";
			break;
		case 4:
			series.name = "일사량";
			series.visible = dataMap.get('insol');
			series.axisYIndex = 1;
			series.color = "#F39D64";
			break;
		case 5:
			series.name = "토양온도";
			series.visible = dataMap.get('soilTemp');
			series.axisYIndex = 0;
			series.color = "#FA5B52";
			break;
		case 6:
			series.name = "토양습도";
			series.visible = dataMap.get('soilHumi');
			series.axisYIndex = 0;
			series.axisYType = "secondary";
			series.color = "#598AD2";
			break;
		case 7:
			series.name = "EC";
			series.visible = dataMap.get('ec');
			series.axisYIndex = 1;
			series.color = "#26AB64";
			break;
		case 8:
			series.name = "PH";
			series.visible = dataMap.get('ph');
			series.axisYIndex = 0;
			series.color = "#8161BC";
			break;
		case 9:
			series.name = "CO2";
			series.visible = dataMap.get('co2');
			series.axisYIndex = 0;
			series.color = "#67aaf5";
			break;
		} // end switch
		
		chartData.push(series);
	} // end for
		

	//
	// 데이터 준비
	//
	let length = dataList.getTotalRow();
	for(let i =0; i<length; i++) {
		let row = dataList.getRowJSON(i);
		let dt = getFormatStringToDate(row.insertDt);
		
		// 온도
		chartData[0].dataPoints.push({
			x: dt,
			y: toFixed(row.temp, 2)
		});
		
		// 습도
		chartData[1].dataPoints.push({
			x: dt,
			y: toFixed(row.humi, 2)
		});
		
		// 이슬점
		chartData[2].dataPoints.push({
			x: dt,
			y: toFixed(convertDP(row.temp, row.humi), 2)
		});
		
		// 수분부족
		chartData[3].dataPoints.push({
			x: dt,
			y: toFixed(convertHD(row.temp, row.humi), 2)
		});
		
		// 일사량
		chartData[4].dataPoints.push({
			x: dt,
			y: row.insol && toFixed(row.insol, 2) || '--'
		});
		
		// 토양온도
		chartData[5].dataPoints.push({
			x: dt,
			y: row.soilTemp && toFixed(row.soilTemp, 2) || '--'
		});
		
		// 토양습도
		chartData[6].dataPoints.push({
			x: dt,
			y: row.soilHumi && toFixed(row.soilHumi, 2) || '--'
		});
		
		// EC
		chartData[7].dataPoints.push({
			x: dt,
			y: row.ec && toFixed(row.ec, 2) || '--'
		});
		
		// PH
		chartData[8].dataPoints.push({
			x: dt,
			y: row.ph && toFixed(row.ph, 2) || '--'
		});
		
		// CO2
		chartData[9].dataPoints.push({
			x: dt,
			y: row.co2 && toFixed(row.co2, 2) || '--'
		});
		
	} // end for

	
	//
	// sort
	//
	for (var i = 0; i < 9; ++i) {
		sortDesc(chartData[i].dataPoints, "x");
	}


	//
	// 라이브러리 세팅 및 랜더링
	//
	chartOption.data = chartData 
	var chartObj = new CanvasJS.Chart(chartContainerId, chartOption);
	chartObj.render();
	
}
