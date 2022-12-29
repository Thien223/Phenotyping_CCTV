
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyyMMddHHmmss"
var="yyyyMMddHHmmss" />
<!-- yyyyMMddHHmmss : ${yyyyMMddHHmmss} -->
<fmt:formatDate value="${now}" pattern="yyyyMMddHHmmssSSS"
var="yyyyMMddHHmmssSSS" />
<!-- yyyyMMddHHmmssSSS : ${yyyyMMddHHmmssSSS} -->
<%
//REQ_META
String protocol = request.getProtocol();
String scheme = request.getScheme();
String serverName = request.getServerName();
String clientIp = egov.com.itconv.helper.IpAddrHelper.getClientIpAddr(request);
int serverPort = request.getServerPort();
int remotePort = request.getRemotePort();
int localPort = request.getLocalPort();

StringBuilder sb = new StringBuilder("\n");

sb.append(":: /WEB-INF/views/websquare/websquare.jsp ::").append("\n");
sb.append("protocol : " + protocol).append("\n");
sb.append("scheme : " + scheme).append("\n");
sb.append("serverName : " + serverName).append("\n");
sb.append("clientIp : " + clientIp).append("\n");
sb.append("serverPort : " + serverPort).append("\n");
sb.append("remotePort : " + remotePort).append("\n");
sb.append("localPort : " + localPort).append("\n");

System.out.println(sb.append("\n"));

request.setAttribute("protocol", protocol);
request.setAttribute("scheme", scheme);
request.setAttribute("serverName", serverName);
request.setAttribute("clientIp", clientIp);
request.setAttribute("serverPort", serverPort);
request.setAttribute("remotePort", remotePort);
request.setAttribute("localPort", localPort);

%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="x-ua-compatible" content="ie=edge">

  <title>CCTV 모니터링</title>
  <link rel="stylesheet" href="/js/cctv_helper/plugins/fontawesome-free/css/all.min.css">
  <link rel="stylesheet" href="/css/cctv_helper/adminlte.min.css">
  <link rel="stylesheet" href="/js/cctv_helper/plugins/sweetalert2/sweetalert2.min.css">
  <link rel="stylesheet" href="/css/cctv_helper/index.css">
  <link rel="stylesheet" href="/css/cctv_helper/fullmulti.css">
  <link href="/css/cctv_helper/google-fonts.css" rel="stylesheet">
  <script>
  let cameraList = [];
  </script>
</head>

<body class="hold-transition layout-top-nav img-background">

  <div class="wrapper">

    <!-- Navbar -->
    <nav class="main-header navbar navbar-expand-md navbar-light navbar-dark">
      <div class="container-fluid">


        <button class="navbar-toggler order-1" type="button" data-toggle="collapse" data-target="#navbarCollapse"
          aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse order-3" id="navbarCollapse">
          <ul class="order-1 order-md-3 navbar-nav navbar-no-expand ml-auto">

            <li class="nav-item dropdown">
              <a href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
                class="nav-link dropdown-toggle"><i class="fas fa-photo-video"></i></a>
              <div class="dropdown-menu dropdown-menu-right custom-dropdown">
                <div class="custom-dropdown-item with-img" onclick="changeBackground('back')">
                  <img src="/css/cctv_helper/img/back.jpg" />
                </div>
                <div class="custom-dropdown-item with-img" onclick="changeBackground('red')">
                  <img src="/css/cctv_helper/img/red.jpg" />
                </div>
                <div class="custom-dropdown-item with-img" onclick="changeBackground('green')">
                  <img src="/css/cctv_helper/img/green.jpg" />
                </div>
                <div class="custom-dropdown-item with-img" onclick="changeBackground('white')">
                  <img src="/css/cctv_helper/img/white.jpg" />
                </div>
              </div>
            </li>
            <!-- <li class="nav-item dropdown">
              <a id="defaultGrid" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
                class="nav-link dropdown-toggle"><i class="fas fa-th-large"></i></a>
              <div aria-labelledby="defaultGrid" class="dropdown-menu dropdown-menu-right custom-dropdown">
                <div class="custom-dropdown-item grid-maker" grid="4" onclick="gridMaker(cameraList.length, cameraList)">
                  2 x 2
                </div>
                <div class="custom-dropdown-item grid-maker" grid="6" onclick="gridMaker(6, cameraList)">
                  3 x 2
                </div>
                <div class="custom-dropdown-item grid-maker" grid="9" onclick="gridMaker(9, cameraList)">
                  3 x 3
                </div>
                <div class="custom-dropdown-item grid-maker" grid="12" onclick="gridMaker(12, cameraList)">
                  4 x 3
                </div>
                <div class="custom-dropdown-item grid-maker" grid="16" onclick="gridMaker(16, cameraList)">
                  4 x 4
                </div>
                <div class="custom-dropdown-item grid-maker" grid="20" onclick="gridMaker(20, cameraList)">
                  4 x 5
                </div>
                <div class="custom-dropdown-item grid-maker" grid="36" onclick="gridMaker(36)">
                  6 x 6
                </div>
                <div class="custom-dropdown-item grid-maker" grid="49" onclick="gridMaker(49)">
                  7 x 7
                </div>
              </div>
            </li> -->
            <!-- <li class="nav-item dropdown">
              <input type="hidden" id="defaultPlayer" value="mse" />
              <a id="defaultPlayerMenu" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
                class="nav-link dropdown-toggle">MSE</a>
              <ul aria-labelledby="defaultPlayerMenu" class="dropdown-menu  custom-dropdown">
                <li><a href="#" class="dropdown-item" onclick="defaultPlayer('mse',this)">MSE</a></li>
                <li><a href="#" class="dropdown-item" onclick="defaultPlayer('hls',this)">HLS</a></li>
                <li><a href="#" class="dropdown-item" onclick="defaultPlayer('webrtc',this)">WebRTC</a></li>
              </ul>
            </li> -->
            <!-- <li class="nav-item">
              <a class="nav-link" href="/" role="button"><i class="fas fa-times"></i> Close</a>
            </li> -->
          </ul>
        </div>
      </div>
    </nav>
    <!-- content -->
    <div class="content-wrapper p-0">
      <div class="content  p-0">
        <div class="container-fluid  p-0" style="overflow: hidden;">
          <div class="grid-wrapper" id="grid-wrapper">

          </div>
          <div class="main-player-wrapper d-none">

            <div class="main-player" data-player="none" data-uuid="0">
              <video class="main-video-player" id="videoPlayer" autoplay muted playsinline></video>
              <div class="play-info"> </div>
              <img class="loader d-none" src="/css/cctv_helper/img/loader.svg" />
              <canvas id="canvas" class="d-none"></canvas>
              <input type="hidden" id="uuid" value="0" />
            </div>
            <a onclick="closeMain()"><i class="fas fa-times"></i></a>
          </div>


        </div>
      </div>

      <!-- foot -->
    </div>
    <!-- content-wrapper -->
    <!-- STREAMS LIST -->
    <aside class="control-sidebar custom">
      <!-- Control sidebar content goes here -->
      <p>
        <a class="control-sidebar-close-btn pull-right" href="#"
          onclick="$('.control-sidebar').ControlSidebar('collapse')"><i class="fas fa-times"></i></a>
      </p>

      <h5>Available streams:</h5>
      <input type="hidden" id="player-index" value="0" />
      <div class="row">
        <div class="col-12" id="a">
          <div class="card  card-success">
            <div id="carousel_a" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('a',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV1</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="b">
          <div class="card  card-success">
            <div id="carousel_b" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('b',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV2</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="c">
          <div class="card  card-success">
            <div id="carousel_c" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('c',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV3</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="d">
          <div class="card  card-success">
            <div id="carousel_d" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('d',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV4</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="e">
          <div class="card  card-success">
            <div id="carousel_e" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('e',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV5</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="f">
          <div class="card  card-success">
            <div id="carousel_f" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('f',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV6</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="g">
          <div class="card  card-success">
            <div id="carousel_g" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('g',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV7</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="h">
          <div class="card  card-success">
            <div id="carousel_h" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('h',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV8</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="i">
          <div class="card  card-success">
            <div id="carousel_i" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('i',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV9</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="j">
          <div class="card  card-success">
            <div id="carousel_j" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('j',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV10</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="k">
          <div class="card  card-success">
            <div id="carousel_k" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('k',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV11</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="l">
          <div class="card  card-success">
            <div id="carousel_l" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('l',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV12</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="m">
          <div class="card  card-success">
            <div id="carousel_m" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('m',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV13</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="n">
          <div class="card  card-success">
            <div id="carousel_n" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('n',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV14</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="o">
          <div class="card  card-success">
            <div id="carousel_o" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('o',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV15</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="p">
          <div class="card  card-success">
            <div id="carousel_p" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('p',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV16</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="q">
          <div class="card  card-success">
            <div id="carousel_q" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('q',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV17</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="r">
          <div class="card  card-success">
            <div id="carousel_r" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('r',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV18</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

        <div class="col-12" id="s">
          <div class="card  card-success">
            <div id="carousel_s" class="carousel slide" data-ride="carousel">

              <div class="carousel-inner">

                <div class="carousel-item  active">
                  <a onclick="play('s',null,0)" href="#"><img class="d-block w-100 stream-img" channel="0"
                      src="/css/cctv_helper/img/noimage.svg"></a>
                  <div class="carousel-caption d-none d-md-block">
                    <h5>CCTV19</h5>
                  </div>
                </div>


              </div>
            </div>

          </div>
        </div>

      </div>
    </aside>

  </div>
  <!-- ./wrapper -->
  <script>
    let streams = {
      "a": { "name": "CCTV1", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "b": { "name": "CCTV2", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "c": { "name": "CCTV3", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "d": { "name": "CCTV4", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "e": { "name": "CCTV5", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "f": { "name": "CCTV6", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "g": { "name": "CCTV7", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "h": { "name": "CCTV8", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "i": { "name": "CCTV9", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "j": { "name": "CCTV10", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "k": { "name": "CCTV11", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "l": { "name": "CCTV12", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "m": { "name": "CCTV13", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "n": { "name": "CCTV14", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "o": { "name": "CCTV15", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "p": { "name": "CCTV16", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "q": { "name": "CCTV17", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "r": { "name": "CCTV18", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } },
      "s": { "name": "CCTV19", "channels": { "0": { "name": "ch1", "url": "", "on_demand": true } } }
    };
    let presetOptions = { "grid": 0, "player": null };
    let get_query = { "controls": [""] };
  </script>
  <script src="/js/cctv_helper/plugins/jquery/jquery.min.js"></script>
  <script src="/js/cctv_helper/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="/js/cctv_helper/adminlte.min.js"></script>
  <script src="/js/cctv_helper/plugins/sweetalert2/sweetalert2.min.js"></script>
  <script src="/js/cctv_helper/index.js"></script>


</body>

</html>
<!-- end foot     -->
<script src="/js/cctv_helper/plugins/hlsjs/hls.min.js"></script>
<script>




  let colordebug = false;

  let players = {};
  $(document).ready(() => {
    
    
    //const a = new String('"'+(${liveChannel}).toString()+'"');
    
    let str_cameraList = "${liveChannel}";
    let cameraList = str_cameraList.match(/.{1,2}/g)
    gridMaker(cameraList.length, cameraList);
/* 	
	switch (${liveChannel}) {
	  case 1: /// 인공활경실
	    cameraList = [0, 1, 2, 3];
	    gridMaker(4, cameraList);
	    break;
	  case 2: /// 온실 외부 6동
	    cameraList = [13, 14, 15, 16, 17, 18];
	    gridMaker(6, cameraList);
	    break;
	  case 3: /// 컨베이어 온실
	    cameraList = [9, 10, 11, 12];
	    gridMaker(4, cameraList);
	    break;
	  case 4: //// 촬영실 + 양액실 
	    cameraList = [4, 5, 6, 7, 8];
	    gridMaker(6, cameraList);
	    break;
	  case 5: ///all 
	    cameraList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
	    gridMaker(20, cameraList);
	    break;
	  default:
		cameraList = [0, 1, 2, 3];
	    gridMaker(4, cameraList);
	    break;
	}
 */
    changeBackground(localStorage.getItem('backgroundImage'));
    if ('grid' in get_query) {
      let get_grid = get_query.grid[0] || 4;
      multiviewGrid('set', get_grid);
    }
    if (presetOptions.grid != 0) {
      multiviewGrid('set', presetOptions.grid);
    }

    if (presetOptions.player != null) {
      localStorage.setItem('multiviewPlayers', JSON.stringify(presetOptions.player));
    }
    gridMaker(cameraList.length, cameraList);
    restoreStreams(cameraList);
  });

  function defaultPlayer(type, el) {
    $('#defaultPlayer').val(type);
    $(el).closest('.nav-item').children('a').html($(el).text());
  }

  function gridMaker(col = 4, cameraList = null) {
    let grid_sizes = [4, 6, 9, 12, 16, 20, 36, 49];
    col = parseInt(col);
    col = grid_sizes.filter(v => v >= col)[0] || 4;
    let colW;
    switch (col) {
      case 6:
        colW = 'grid-6';
        break;
      case 9:
        colW = 'grid-9';
        break;
      case 12:
        colW = 'grid-12';
        break;
      case 16:
        colW = 'grid-16';
        break;
      case 20:
        colW = 'grid-20';
        break;
      case 36:
        colW = 'grid-36';
        break;
      case 49:
        colW = 'grid-49';
        break;
      default:
        colW = '';
        break;
    }
    let memory = localStorage.getItem('multiviewPlayers');
    destroyGrid();
    for (var i = 0; i < col; i++) {
      $('#grid-wrapper').append(
        `<div class=" player ` + colW + ` empty" data-player="none" data-uuid="0">
              <div class="play-info"></div>
              <video class="video-class empty" autoplay muted playsinline></video>
            ` +
        /* `<a class="remove-btn" onclick="destoyPlayer(` + i + `)"><i class="fas fa-times"></i></a>` + */
        /* `<a class="add-stream-btn" onclick="openChoise(this)"><i class="fas fa-plus"></i><br />CCTV 추가</a>` + */
        `<a href="#" class="btn  btn-info btn-xs btn-play-main d-none"  onclick="playMainStream(this)"><i class="fas fa-expand"></i> Expand</a>` +
        `<img class="loader d-none" src="/css/cctv_helper/img/loader.svg" />` +
        `</div>`);
    }
    multiviewGrid('set', col);
    addEventListenerToVideo();
    $('.grid-maker').removeClass('active');
    $('.grid-maker[grid="' + col + '"]').addClass('active');
    if (cameraList != null) {
      //localStorage.setItem('multiviewPlayers', memory);
      restoreStreams(cameraList);
    }
  }

  function addEventListenerToVideo() {
    $('.video-class').each(function () {
      let _this = this;
      let index = $(this).closest('.player').index();
      let uuid = $(this).closest('.player').attr('data-uuid');

      this.addEventListener('loadeddata', () => {
        _this.play();
        makePic(this, $(_this).closest('.player').attr('data-uuid'), 1);
        logger(index, '[video]: loadeddata');
      });
      this.addEventListener('stalled', () => {
        logger(index, '[video]: stalled');
      });
      this.addEventListener('pause', () => {
        if (_this.currentTime > _this.buffered.end(_this.buffered.length - 1)) {
          _this.currentTime = _this.buffered.end(_this.buffered.length - 1) - 0.1;
          _this.play();
        }
        logger(index, '[video]: pause');
      });

      this.addEventListener('error', (e) => {
        logger(index, '[video]: error', e);
        //console.log(e);
      });

      this.addEventListener('abort', () => {
        logger(index, '[video]: abort');
      });

      this.addEventListener('emptied', (e) => {
        logger(index, '[video]: emptied');
      });

      this.addEventListener('ended', (e) => {
        logger(index, '[video]: ended');
      });

      this.addEventListener('play', (e) => {
        logger(index, '[video]: play');
      });

      this.addEventListener('suspend', (e) => {
        logger(index, '[video]: suspend');
      });
      this.addEventListener('waiting', (e) => {
        logger(index, '[video]: waiting');
      });
      this.addEventListener('canplaythrough', (e) => {
        $(_this).closest('div').find('.loader').addClass('d-none');
        logger(index, '[video]: canplaythrough');
      });
      this.addEventListener('playing', (e) => {
        $(_this).closest('div').find('.loader').addClass('d-none');
        logger(index, '[video]: playing');
      });
      this.addEventListener('loadedmetadata', (e) => {
        logger(index, '[video]: loadedmetadata');
      });
      this.addEventListener('loadstart', (e) => {
        logger(index, '[video]: loadstart');
      });
    });
  }

  $('.main-video-player')[0].addEventListener('canplaythrough', (e) => {
    $('.main-player').find('.loader').addClass('d-none');
    logger(0, '[video]: canplaythrough');
  });
  $('.main-video-player')[0].addEventListener('playing', (e) => {
    $('.main-player').find('.loader').addClass('d-none');
    logger(0, '[video]: canplaythrough');
  });

  $("#videoPlayer")[0].addEventListener('loadeddata', () => {
    $("#videoPlayer")[0].play();
    let browser = browserDetector();
    if (!browser.safari) {
      makePic();
    }
  });

  function destroyGrid() {
    $('.player').each(function (index) {
      destoyPlayer(index);
    });
    $('#grid-wrapper').empty();
  }

  function openChoise(dom) {
    $('#player-index').val($(dom).closest('.player').index());
    $('.control-sidebar').ControlSidebar('show')

  }

  function play(uuid, index, chan, typePlayer) {
    $('#uuid').val(uuid);
    if (typeof (index) == 'undefined' || index == null) {
      index = $('#player-index').val();
    }
    let videoPlayerVar = $('.main-player');
    if (index != 'main') {
      videoPlayerVar = $('.player').eq(index);
    }

    $('.control-sidebar').ControlSidebar('collapse');
    destoyPlayer(index);
    videoPlayerVar.removeClass('empty');
    videoPlayerVar.find('video').removeClass('empty');


    let playerType = $('#defaultPlayer').val();
    if (!!typePlayer) {
      playerType = typePlayer;
    }
    videoPlayerVar.attr('data-player', playerType);
    videoPlayerVar.attr('data-uuid', uuid);

    let channel = 0;

    if (typeof (streams[uuid].channels[1]) !== "undefined") {
      channel = 1;
    }

    if (index == 'main') {
      channel = 0;
    } else {
      packStreamms(index, uuid, chan, playerType);
    }
    if (colordebug) {
      videoPlayerVar.find('.play-info').html('Stream: ' + streams[uuid].name + ' | player type:' + playerType + ' | channel: ' + channel);
    }
    videoPlayerVar.find('.loader').removeClass('d-none');
    //fix stalled video in safari
    videoPlayerVar.find('video')[0].addEventListener('pause', () => {
      if (videoPlayerVar.find('video')[0].currentTime > videoPlayerVar.find('video')[0].buffered.end((videoPlayerVar.find('video')[0].buffered.length - 1))) {
        videoPlayerVar.find('video')[0].currentTime = videoPlayerVar.find('video')[0].buffered.end((videoPlayerVar.find('video')[0].buffered.length - 1)) - 0.1;
        videoPlayerVar.find('video')[0].play();
      }
    });

    switch (playerType) {
      case 'hls':
        let url = '/stream/' + uuid + '/channel/' + channel + '/hls/live/index.m3u8';

        if (videoPlayerVar.find('video')[0].canPlayType('application/vnd.apple.mpegurl')) {
          videoPlayerVar.find('video')[0].src = url;
          videoPlayerVar.find('video')[0].load();
        } else if (Hls.isSupported()) {
          players[index] = new Hls({
            manifestLoadingTimeOut: 60000
          });
          players[index].loadSource(url);
          players[index].attachMedia(videoPlayerVar.find('video')[0]);
        } else {
          Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Your browser don`t support hls '
          });
        }
        break;
      case 'webrtc':
        players[index] = new WebRTCPlayer(uuid, videoPlayerVar, channel);
        players[index].playWebrtc();
        break;
      case 'mse':
      default:

        players[index] = new msePlayer(uuid, videoPlayerVar, channel);
        players[index].playMse();
        break;
    }

  }

  function destoyPlayer(index) {
    let videoPlayerVar = $('.main-player');
    if (index != 'main') {
      videoPlayerVar = $('.player').eq(index);
    }
    let type = videoPlayerVar.attr('data-player');
    videoPlayerVar.addClass('empty');
    videoPlayerVar.find('video').addClass('empty')

    switch (type) {
      case 'hls':
        if (!!players[index]) {
          players[index].destroy();
          delete players[index];
        }
        break;
      case 'mse':
        players[index].destroy();
        delete players[index];

        break;
      case 'webrtc':
        players[index].destroy();
        delete players[index];
        break;
      default:

        break;
    }
/*     videoPlayerVar.attr('data-player', 'none');
    videoPlayerVar.attr('data-uuid', 0);
    videoPlayerVar.find('.play-info').html('');
    videoPlayerVar.find('video')[0].src = '';
    videoPlayerVar.find('video')[0].load();
    videoPlayerVar.find('.loader').addClass('d-none'); */

    unpackStreams(index);
  }

  function expand(element) {
    fullscreenOn($('#grid-wrapper').parent()[0]);
  }

  function playMainStream(element) {
    let uuid = $(element).closest('.player').attr('data-uuid');
    if (uuid == 0) {
      return;
    }
    $('.main-player-wrapper').removeClass('d-none');
    play(uuid, 'main');
  }

  function closeMain() {
    destoyPlayer('main');
    $('.main-player-wrapper').addClass('d-none');
  }
  /*************************mse obect **************************/
  function msePlayer(uuid, videoPlayerVar, channel) {
    this.ws = null,
      this.video = videoPlayerVar.find('video')[0],
      this.sound = false,
      this.mseSourceBuffer = null,
      this.mse = null,
      this.mseQueue = [],
      this.mseStreamingStarted = false,
      this.uuid = uuid,
      this.channel = channel || 0;
    this.timeout = null;
    this.checktime = null;
    this.checktimecounter = 0;
    this.playMse = function () {
      let _this = this;
      logger(videoPlayerVar.index(),
        'func playMse',
        'streams: ' + uuid,
        'channel: ' + channel);

      this.mse = new MediaSource();
      this.video.src = window.URL.createObjectURL(this.mse);

      let potocol = 'ws';
      if (location.protocol == 'https:') {
        potocol = 'wss';
      }
      //192.168.100.50
      //222.105.187.75
      let ws_url = potocol + '://222.105.187.75:8520/stream/' + this.uuid + '/channel/' + this.channel + '/mse?uuid=' + this.uuid + '&channel=' + this.channel;

      this.mse.addEventListener('sourceopen', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: sourceopen');
        _this.ws = new WebSocket(ws_url);
        _this.ws.binaryType = "arraybuffer";
        _this.ws.onopen = function (event) {

          logger(videoPlayerVar.index(),
            uuid,
            channel,
            '[websocket]: connected');
        }

        _this.ws.onclose = function (event) {
          logger(videoPlayerVar.index(),
            uuid,
            channel,
            '[websocket]: closed');
          if (_this.timeout != null) {
            clearInterval(_this.timeout);
            _this.timeout = null;
          }
          _this.timeout = setTimeout(() => {
            logger(videoPlayerVar.index(),
              uuid,
              channel,
              '[websocket]: timeouted func play');
            play(uuid, videoPlayerVar.index(), channel, 'mse')
          }, 15000)


        }
        _this.ws.onerror = (e) => {
          logger(videoPlayerVar.index(),
            uuid,
            channel,
            '[websocket]: error');
        }
        _this.ws.onmessage = function (event) {
        	try{
          		_this.checkStalled();
        	}catch{
        		
        	}
          let data = new Uint8Array(event.data);
          if (data[3] == 24) {
            logger(videoPlayerVar.index(),
              uuid,
              channel,
              '[data]: init_file');
          }

          if (data[0] == 9) {
            decoded_arr = data.slice(1);
            if (window.TextDecoder) {
              mimeCodec = new TextDecoder("utf-8").decode(decoded_arr);
            } else {
              mimeCodec = Utf8ArrayToStr(decoded_arr);
            }
            if (mimeCodec.indexOf(',') > 0) {
              _this.sound = true;
            }
            logger(videoPlayerVar.index(),uuid,channel,'[codec]: ' + mimeCodec);
            	
           	//var isPlaying = _this.mse.currentTime > 0 && !_this.mse.paused && !_this.mse.ended && _this.mse.readyState > _this.mse.HAVE_CURRENT_DATA;
           	if(_this.mse.readyState == "open"){
           		try{
	            _this.mseSourceBuffer = _this.mse.addSourceBuffer('video/mp4; codecs="' + mimeCodec + '"');
	            _this.mseSourceBuffer.mode = "segments"
	            _this.mseSourceBuffer.addEventListener("updateend", _this.pushPacket.bind(_this));
           		}catch{
           			
           		}
           	}

          } else {
            _this.readPacket(event.data);
          }
        };
      }, false);

      this.mse.addEventListener('sourceended', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: sourceended');
      })
      this.mse.addEventListener('sourceclose', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: sourceclose');
      })

      this.mse.addEventListener('error', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: error');
      })
      this.mse.addEventListener('abort', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: abort');
      })
      this.mse.addEventListener('updatestart', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: updatestart');
      })
      this.mse.addEventListener('update', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: update');
      })
      this.mse.addEventListener('updateend', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: updateend');
      })
      this.mse.addEventListener('addsourcebuffer', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: addsourcebuffer');
      })
      this.mse.addEventListener('removesourcebuffer', function () {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[MSE]: removesourcebuffer');
      })

    }

    this.readPacket = function (packet) {
      if (!this.mseStreamingStarted) {
        try {
          this.mseSourceBuffer.appendBuffer(packet);
          this.mseStreamingStarted = true;
        } catch (e) {
          logger(videoPlayerVar.index(),
            'readPacket error',
            'streams: ' + uuid,
            'channel: ' + channel);

          //console.log("play videoPlayerVar.index() 2: ", videoPlayerVar.index());
          //play(uuid, videoPlayerVar.index(), channel, 'mse');

        } finally {
          return;
        }


      }
      this.mseQueue.push(packet);

      if (!this.mseSourceBuffer.updating) {
        this.pushPacket();
      }
    },

      this.pushPacket = function () {
        let _this = this;
        if (!_this.mseSourceBuffer.updating) {
          if (_this.mseQueue.length > 0) {
            packet = _this.mseQueue.shift();

            try {
              _this.mseSourceBuffer.appendBuffer(packet)
            } catch (e) {
              logger(videoPlayerVar.index(),
                'pushPacket error',
                'streams: ' + uuid,
                'channel: ' + channel);
              play(uuid, videoPlayerVar.index(), channel, 'mse');
            } finally {

            }
          } else {
            _this.mseStreamingStarted = false;
          }
        }
        if (_this.video.buffered.length > 0) {
          if (typeof document.hidden !== "undefined" && document.hidden) {
            if (!_this.sound) {
              _this.video.currentTime = _this.video.buffered.end((_this.video.buffered.length - 1)) - 0.5;
            }
          } else {
            if ((_this.video.buffered.end((_this.video.buffered.length - 1)) - _this.video.currentTime) > 60) {
              _this.video.currentTime = _this.video.buffered.end((_this.video.buffered.length - 1)) - 0.5;
            }
          }
        }
      }
    this.checkStalled = function () {
      if (!!this.video.currentTime) {
        if (this.video.currentTime == this.checktime) {
          this.checktimecounter += 1;
        } else {
          this.checktimecounter = 0;
        }
      }
      if (this.checktimecounter > 10) {
        logger(videoPlayerVar.index(),
          uuid,
          channel,
          '[FIX]: player not move');

        play(uuid, videoPlayerVar.index(), channel, 'mse');
      }
      this.checktime = this.video.currentTime;

    },
      this.destroy = function () {
        if (this.timeout != null) {
          clearInterval(this.timeout);
        }
        if (this.ws != null) {

          this.ws.onclose = null;
          this.ws.close(1000, "stop streaming");
        }



        logger(videoPlayerVar.index(),
          'Event: PlayerDestroy',
          'streams: ' + uuid,
          'channel: ' + channel);
      }
  }
  /*************************end mse obect **************************/
  /*************************WEBRTC obect **************************/
  function WebRTCPlayer(uuid, videoPlayerVar, channel) {
    this.webrtc = null;
    this.webrtcSendChannel = null;
    this.webrtcSendChannelInterval = null;
    this.uuid = uuid;
    this.video = videoPlayerVar.find('video')[0];
    this.channel = channel || 0;
    this.playWebrtc = function () {
      var _this = this;
      this.webrtc = new RTCPeerConnection({
        iceServers: [{
          urls: ["stun:stun.l.google.com:19302"]
        }]
      });
      this.webrtc.onnegotiationneeded = this.handleNegotiationNeeded.bind(this);
      this.webrtc.ontrack = function (event) {
        _this.video.srcObject = event.streams[0];
        _this.video.play();
      }
      this.webrtc.addTransceiver('video', {
        'direction': 'sendrecv'
      });
      this.webrtcSendChannel = this.webrtc.createDataChannel('foo');
      this.webrtcSendChannel.onclose = (e) => console.log('sendChannel has closed', e);
      this.webrtcSendChannel.onopen = () => {
        console.log('sendChannel has opened');
        this.webrtcSendChannel.send('ping');
        this.webrtcSendChannelInterval = setInterval(() => {
          this.webrtcSendChannel.send('ping');
        }, 1000)
      }

      this.webrtcSendChannel.onmessage = e => console.log(e.data);
    },
      this.handleNegotiationNeeded = async function () {
        var _this = this;

        offer = await _this.webrtc.createOffer();
        await _this.webrtc.setLocalDescription(offer);
        $.post("http://222.105.187.75:8520/stream/" + _this.uuid + "/channel/" + this.channel + "/webrtc?uuid=" + _this.uuid + "&channel=" + this.channel, {
          data: btoa(_this.webrtc.localDescription.sdp)
        }, function (data) {
          try {
            _this.webrtc.setRemoteDescription(new RTCSessionDescription({
              type: 'answer',
              sdp: atob(data)
            }))
          } catch (e) {
            console.warn(e);
          }

        });
      }

    this.destroy = function () {
      clearInterval(this.webrtcSendChannelInterval);
      console.log('Closed..');
      this.webrtc.close();
      this.video.srcObject = null;
    }
  }

  /*********************FULSCREEN******************/
  function fullscreenEnabled() {
    return !!(
      document.fullscreenEnabled ||
      document.webkitFullscreenEnabled ||
      document.mozFullScreenEnabled ||
      document.msFullscreenEnabled
    );
  }

  function fullscreenOn(elem) {
    if (elem.requestFullscreen) {
      elem.requestFullscreen();
    } else if (elem.mozRequestFullScreen) {
      elem.mozRequestFullScreen();
    } else if (elem.webkitRequestFullscreen) {
      elem.webkitRequestFullscreen();
    } else if (elem.msRequestFullscreen) {
      elem.msRequestFullscreen();
    }
  }

  function fullscreenOff() {
    if (document.requestFullscreen) {
      document.requestFullscreen();
    } else if (document.webkitRequestFullscreen) {
      document.webkitRequestFullscreen();
    } else if (document.mozRequestFullscreen) {
      document.mozRequestFullScreen();
    }
  }

  function packStreamms(index, uuid, channel, type) {
    let multiviewPlayers;
    if (localStorage.getItem('multiviewPlayers') != null && false) {
      multiviewPlayers = JSON.parse(localStorage.getItem('multiviewPlayers'));
    } else {
      multiviewPlayers = {};
    }
    multiviewPlayers[index] = {
      uuid: uuid,
      channel: channel,
      playerType: type
    }
    //localStorage.setItem('multiviewPlayers', JSON.stringify(multiviewPlayers));
  }

  function unpackStreams(index) {
    if (localStorage.getItem('multiviewPlayers') != null && false) {
      let multiviewPlayers = JSON.parse(localStorage.getItem('multiviewPlayers'));
      delete multiviewPlayers[index];
      localStorage.setItem('multiviewPlayers', JSON.stringify(multiviewPlayers));
    }
  }

  function restoreStreams(cameraList = null) {

    if (localStorage.getItem('multiviewPlayers') != null && false) {
      let multiviewPlayers = JSON.parse(localStorage.getItem('multiviewPlayers'));
      if (Object.keys(multiviewPlayers).length > 0) {
        $.each(multiviewPlayers, function (key, val) {

          if (val.uuid in streams && val.channel in streams[val.uuid].channels) {
            if ($('.player').eq(key).length > 0) {
              play(val.uuid, key, val.channel, val.playerType);
            }
          } else {
            unpackStreams(key);
          }
        })
      }

    } else {
      if (Object.keys(streams).length > 0) {
        //gridMaker(Object.keys(streams).length);
        let playerIndex = 0;
        let gridSize = $('.player').length;
        
        if (cameraList != null) {
          for (var i = 0 ; i < cameraList.length; i ++) {
       	    idx = parseInt(cameraList[i])-1; /// start from 0
        	var uuid = Object.keys(streams)[idx];
            var channel = Object.keys( streams[uuid].channels)[0]==null?0:Object.keys( streams[uuid].channels)[0];
            if (playerIndex < gridSize) {
                play(uuid, playerIndex, channel, 'mse');
                playerIndex++;
              } else {
                return;
              }
            
          }
        } else {
          $.each(streams, function (uuid, params) {
            if (playerIndex < gridSize) {
              let channel = 0;
              if ('1' in params.channels) {
                channel = 1;
              }
              play(uuid, playerIndex, channel, 'mse');
              playerIndex++;
            } else {
              return;
            }


          })
        }
      }

    }
  }

  function multiviewGrid(type, grid) {
    let defGrid = 25;
    switch (type) {
      case 'set':
        localStorage.setItem('multiviewGrid', grid);
        break;
      case 'get':
        if (localStorage.getItem('multiviewGrid') != null) {
          return localStorage.getItem('multiviewGrid');
        } else {
          return defGrid
        }
        break;
      default:
        return defGrid
    }
    return defGrid
  }

  $('#grid-wrapper').on('dblclick', '.player', function () {
    $(this).find('.btn-play-main').click();
  });
  $('.main-player').on('dblclick', function () {
    closeMain()
  });

  function changeBackground(num) {
    let back = '/css/cctv_helper/img/';
    localStorage.setItem('backgroundImage', num);
    switch (num) {
      case 'green':
        back += 'green.jpg'
        break;
      case 'red':
        back += 'red.jpg'
        break;
      case 'white':
        back += 'white.jpg'
        break;
      default:
        back += 'back.jpg'
    }
    $('.img-background').css('background-image', 'url("' + back + '")');
  }
  
  
  
</script>