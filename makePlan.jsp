<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="en">

<head>


<title>Zero To One Plan</title>


<!-- 부트스트랩 환경 -->
<%@ include file="/WEB-INF/views/bootStrap.jsp"%>
<link href="/resources/css/makePlan.css" rel="stylesheet">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>

<!-- 로그아웃/만족도조사 -->
<link href="/resources/css/index.css" rel="stylesheet">


</head>
<body>
	<!------------------------------- 화면 그리드 ------------------------------->
	<div class="grid-container">
		<div class="grid-item top">
			<img src="/resources/img/gridTm.jpg" usemap="#linkTop"
				style="position: relative;">
			<%
			if (!request.isUserInRole("ROLE_ADMIN")) {
			%>
			<div
				style="background-color: #f6f8ff; position: absolute; top: 62px; left: 1709px; width: 70px; height: 49px;"></div>
			<%
			}
			%>
			<map name="linkTop" id="linkTop">
				<area shape="rect" coords="119,62,168,109"
					href="https://www.facebook.com/MiraeAssetLife" target="_blank">
				<area shape="rect" coords="195,62,255,109"
					href="https://blog.naver.com/miraeasset_0" target="_blank">
				<area shape="rect" coords="278,62,331,109"
					href="https://www.youtube.com/channel/UCvkGWwHt8YiUF3xN9GrGYjw"
					target="_blank">
				<%
				if (request.isUserInRole("ROLE_ADMIN")) {
				%>
				<area shape="rect" coords="1709,62,1768,109" href="/admin">
				<%
				}
				%>
				<sec:authorize access="isAuthenticated()">
					<area shape="rect" coords="1769,62,1821,109" data-bs-toggle="modal"
						data-bs-target="#opinionModal">
				</sec:authorize>
			</map>
		</div>
		<div class="grid-item left">
			<img src="/resources/img/gridLm.jpg" usemap="#link">
			<map name="link" id="link">
				<area shape="rect" coords="90,12,270,94" href="/">
				<area shape="rect" coords="90,102,270,272" href="/customer/list">
				<area shape="rect" coords="90,273,270,453"
					href="/product/productCustomer">
				<area shape="rect" coords="90,454,270,635"
					href="/contract/contractMgt">
				<area shape="rect" coords="90,636,270,692" href="/board/boardList/1">
			</map>
		</div>

		<div class="grid-item center-outer">

			<div class="center-inner">
				<!------------------------------- 화면 그리드 ------------------------------->



				<img src="/resources/img/step2.JPG" alt="processpage"
					id="contractStep">
				<main id="main" class="main">

					<div class="pagetitle">

						<h1></h1>
					</div>
					<!-- End Page Title -->

					<section class="section dashboard">
						<div class="row">

							<!-- Left side columns -->
							<div class="col-lg-9">

								<div class="row">


									<!-- Reports -->
									<div class="col-12">
										<div class="card top-selling overflow-auto">



											<div class="card-body">
												<h5 class="card-title">
													<b> 선택상품</b> <span>| <label for="productCategory"></label>
														<input type="hidden" value="${productDTO.category}"
														id="productCategory"> <input type="hidden"
														value="${productDTO.id}" id="productId">
														${productDTO.name}



													</span>
												</h5>

												<table class="type09" id="mainTable">
													<colgroup>
														<col style="width: 15%;" />

														<col style="width: 20%;" />
														<col style="width: 10%;" />
														<col style="width: 10%;" />
													</colgroup>
													<thead>
														<tr>

															<th scope="col">주계약명</th>
															<th scope="col">가입한도(만원)</th>
															<th scope="col">가입금액(만원)</th>
															<th scope="col">보험료(원)</th>
															<th scope="col">납입기간</th>
															<th scope="col">보험기간</th>
															<th scope="col">납입주기</th>
														</tr>
													</thead>
													<tr>

														<td><c:forEach var="option" items="${dataMap}">

																<c:forEach var="code" items="${option.value.code}">
																	<c:choose>
																		<c:when test="${code eq '01'}">
																	            ${option.key}
																	         </c:when>
																	</c:choose>
																</c:forEach>
															</c:forEach></td>
														<td><c:forEach var="option" items="${dataMap}">
																<c:forEach var="code" items="${option.value.code}">

																	<c:choose>
																		<c:when test="${code eq '01'}">
																			<c:forEach var="minA" items="${option.value.minA}">
																				<input type="hidden" id="mainMinA" value="${minA}">${minA}
																					</c:forEach>~<c:forEach var="MaxA" items="${option.value.MaxA}">${MaxA}
																					            <input type="hidden" id="mainMaxA"
																					value="${MaxA}">
																			</c:forEach>

																		</c:when>
																	</c:choose>
																</c:forEach>
															</c:forEach></td>

														<!-- 일반상품과 변액상품별 가입금액 활성화/비활성화처리 -->
														<td><c:choose>
																<c:when test="${productDTO.category eq '01'}">
																	<input type="text" style="text-align: right;"
																		class="number-input">
																	<!-- id ajax 중복체크 -->
																	<span class="id_already">가입금액을 입력해주세요</span>
																	<span class="mainminmax_ok">가입한도를 확인해주세요</span>

																</c:when>
																<c:when test="${productDTO.category eq '02'}">
																	<input type="text" disabled id="varibleAmount"
																		class="number-input" style="text-align: right;">

																	<span class="mainminmax_ok">가입한도를 확인해주세요</span>
																</c:when>
															</c:choose></td>

														<td><c:choose>
																<c:when test="${productDTO.category eq '01'}">
																	<input type="text" id="mainPremium"
																		class="number-input" disabled
																		style="text-align: right;">
																</c:when>
																<c:when test="${productDTO.category eq '02'}">
																	<input type="text" id="variblePremium"
																		class="number-input" style="text-align: right;">
																	<span class="variblePremium_ok">보험료를 입력해주세요</span>
																</c:when>
															</c:choose></td>
														<td><c:forEach var="option" items="${dataMap}">
																<c:forEach var="code" items="${option.value.code}">
																	<c:choose>
																		<c:when test="${code eq '01'}">
																			<select>
																				<c:forEach var="payTerm"
																					items="${option.value.payTerm}">



																					<option value="${payTerm}">${payTerm}년납</option>
																				</c:forEach>
																			</select>
																		</c:when>
																	</c:choose>
																</c:forEach>
															</c:forEach></td>
														<td><c:forEach var="option" items="${dataMap}">
																<c:forEach var="code" items="${option.value.code}">

																	<c:choose>
																		<c:when test="${code eq '01'}">

																			<select>
																				<c:forEach var="iTerm" items="${option.value.iTerm}">
																					<option value="${iTerm}">${iTerm}년만기</option>
																				</c:forEach>
																			</select>

																		</c:when>
																	</c:choose>

																</c:forEach>
															</c:forEach></td>
														<td><c:forEach var="option" items="${dataMap}">
																<c:forEach var="code" items="${option.value.code}">
																	<c:choose>
																		<c:when test="${code eq '01'}">
																			<select>
																				<c:forEach var="payCycle"
																					items="${option.value.payCycle}">
																					<c:choose>
																						<c:when test="${payCycle eq '01'}">
																							<option value="${payCycle}">월납</option>
																						</c:when>
																					</c:choose>
																				</c:forEach>
																			</select>
																		</c:when>
																	</c:choose>
																</c:forEach>
															</c:forEach></td>


													</tr>
												</table>

											</div>

										</div>
									</div>
									<!-- End Reports -->



									<!-- 특약선택 start -->

									<div class="col-12" id="category01Section">
										<div class="card top-selling overflow-auto">



											<div class="card-body">
												<h5 class="card-title">


													<b>특약선택</b> <span>|선택가능특약</span>


												</h5>

												<table class="type09" id="selectOpt">
													<colgroup>
														<col style="width: 10%;" />
														<col style="width: 20%;" />
														<!-- 특약명 -->
														<col style="width: 20%;" />
														<col style="width: 20%;" />
														<!-- 가입한도 -->
														<col style="width: 10%;" />
														<col style="width: 10%;" />
														<col style="width: 10%;" />
														<col style="width: 30%;" />
														<col style="width: 10%;" />
													</colgroup>
													<thead>
														<tr>
															<th scope="col">선택</th>
															<th scope="col">특약명</th>

															<th scope="col">가입한도(만원)</th>
															<th scope="col">가입금액(만원)</th>
															<th scope="col">보험기간</th>
															<th scope="col">납입기간</th>
															<th scope="col">납입주기</th>
															<th scope="col">보험료</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach var="option" items="${dataMap}">

															<c:if test="${option.value.code eq '[02]'}">
																<%-- <c:if test="${option.value.code eq 02}"> --%>
																<tr>
																	<td class="moveable"><input type="checkbox"
																		id="chkopt"></td>
																	<td>${option.key}</td>

																	<td><c:forEach var="minA"
																			items="${option.value.minA}">${minA}<input
																				type="hidden" value="${minA}" id="optMinA">
																		</c:forEach>~<c:forEach var="MaxA" items="${option.value.MaxA}">${MaxA}<input
																				type="hidden" value="${MaxA}" id="optMaxA">
																		</c:forEach></td>
																	<td><input type="text" value="1,000"
																		class="optAmount" style="text-align: right;"><span
																		class="id_ok">가입금액을 입력해주세요</span> <span
																		class="minmax_ok">가입한도를 확인해주세요</span></td>


																	<td><select><c:forEach var="iTerm"
																				items="${option.value.iTerm}">
																				<option value="${iTerm}">${iTerm}년만기</option>
																			</c:forEach></select></td>
																	<td><select><c:forEach var="payTerm"
																				items="${option.value.payTerm}">
																				<option value="${payTerm}">${payTerm}년납</option>
																			</c:forEach></select></td>
																	<td><select><c:forEach var="payCycle"
																				items="${option.value.payCycle}">
																				<option value="${payCycle}"><c:choose>
																						<c:when test="${payCycle eq '01'}">월납</c:when>
																					</c:choose></option>
																			</c:forEach></select></td>
																	<c:forEach var="optp" items="${optPremium}">
																		<c:choose>
																			<c:when test="${optp.optName eq option.key}">
																				<td><input type="text" class="optPremium"
																					value="${optp.optP}" style="text-align: right;"
																					disabled></td>
																			</c:when>
																		</c:choose>
																	</c:forEach>
																</tr>
															</c:if>
														</c:forEach>
													</tbody>
												</table>
											</div>
										</div>




									</div>
									<!-- 특약선택 end -->


									<!-- 설계바구니 start-->
									<div class="col-12" id="category01Section2">
										<div class="card top-selling overflow-auto">
											<div class="card-body">

												<h5 class="card-title">
													<b>설계바구니</b><span>|선택특약: 개</span>
												</h5>
												<table class="type09" id="selectedOpt">
													<colgroup>
														<col style="width: 5%;" />
														<col style="width: 15%;" />
														<!-- 특약명 -->
														<col style="width: 20%;" />
														<col style="width: 20%;" />
														<!-- 가입한도 -->
														<col style="width: 10%;" />
														<col style="width: 10%;" />
														<col style="width: 10%;" />
														<col style="width: 30%;" />
														<col style="width: 10%;" />
													</colgroup>
													<thead>
														<tr>
															<th scope="col">선택</th>
															<th scope="col">특약명</th>

															<th scope="col">가입한도(만원)</th>
															<th scope="col">가입금액(만원)</th>
															<th scope="col">보험기간</th>
															<th scope="col">납입기간</th>
															<th scope="col">납입주기</th>
															<th scope="col">보험료</th>
														</tr>
													</thead>
													<tbody></tbody>
												</table>

											</div>

										</div>
									</div>
									<!-- End 설계바구니 -->


									<!-- 펀드선택-->
									<div class="col-12" id="category02Section">

										<div class="card top-selling overflow-auto">
											<div class="card-body">
												<h5 class="card-title">
													펀드선택 <span>|펀드는 총 10개까지 선택할 수 있으며, 선택된 펀드의 비율 합계는
														100%여야 합니다. </span>
												</h5>

												<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
													<li class="nav-item" role="presentation">
														<button class="nav-link active" id="pills-home-tab"
															data-bs-toggle="pill" data-bs-target="#pills-home"
															type="button" role="tab" aria-controls="pills-home"
															aria-selected="true">포트폴리오군</button>
													</li>
													<li class="nav-item" role="presentation">
														<button class="nav-link" id="pills-profile-tab"
															data-bs-toggle="pill" data-bs-target="#pills-profile"
															type="button" role="tab" aria-controls="pills-profile"
															aria-selected="false">주식군</button>
													</li>
													<li class="nav-item" role="presentation">
														<button class="nav-link" id="pills-contact-tab"
															data-bs-toggle="pill" data-bs-target="#pills-contact"
															type="button" role="tab" aria-controls="pills-contact"
															aria-selected="false">채권군</button>
													</li>
												</ul>


												<div class="tab-content pt-2" id="myTabContent">
													<div class="tab-pane fade show active" id="pills-home"
														role="tabpanel" aria-labelledby="home-tab">
														<table class="type09" id="selectFund1">
															<colgroup>
																<col style="width: 20%;" />
																<col style="width: 50%;" />
																<col style="width: 30%;" />
															</colgroup>
															<thead>
																<tr>
																	<th scope="col">선택</th>
																	<th scope="col">펀드명</th>
																	<th scope="col">비율(%)</th>


																</tr>
															</thead>
															<c:forEach var="fund" items="${fundList}">
																<c:choose>
																	<c:when test="${fund.category eq '포트폴리오'}">
																		<tr>
																			<td><input type="checkbox"></td>
																			<td>[${fund.type}] ${fund.name} (${fund.id}) <input
																				type="hidden" value="${fund.id}"></td>
																			<td><input type="text"></td>
																		</tr>
																	</c:when>
																</c:choose>
															</c:forEach>
														</table>
													</div>
													<div class="tab-pane fade" id="pills-profile"
														role="tabpanel" aria-labelledby="profile-tab">
														<table class="type09" id="selectFund2">
															<colgroup>
																<col style="width: 20%;" />
																<col style="width: 50%;" />
																<col style="width: 30%;" />
															</colgroup>
															<thead>
																<tr>
																	<th scope="col">선택</th>
																	<th scope="col">펀드명</th>
																	<th scope="col">비율(%)</th>


																</tr>
															</thead>
															<c:forEach var="fund" items="${fundList}">
																<c:choose>
																	<c:when test="${fund.category eq '주식군'}">
																		<tr>
																			<td><input type="checkbox"></td>
																			<td>[${fund.type}] ${fund.name} (${fund.id})<input
																				type="hidden" value="${fund.id}"></td>
																			<td><input type="text"></td>
																		</tr>
																	</c:when>
																</c:choose>
															</c:forEach>
														</table>
													</div>
													<div class="tab-pane fade" id="pills-contact"
														role="tabpanel" aria-labelledby="contact-tab">
														<table class="type09" id="selectFund3">
															<colgroup>
																<col style="width: 20%;" />
																<col style="width: 50%;" />
																<col style="width: 30%;" />
															</colgroup>
															<thead>
																<tr>
																	<th scope="col">선택</th>
																	<th scope="col">펀드명</th>
																	<th scope="col">비율(%)</th>


																</tr>
																<c:forEach var="fund" items="${fundList}">
																	<c:choose>
																		<c:when test="${fund.category eq '채권군'}">
																			<tr>
																				<td><input type="checkbox"></td>
																				<td>[${fund.type}] ${fund.name} (${fund.id})<input
																					type="hidden" value="${fund.id}"></td>
																				<td><input type="text"></td>
																			</tr>
																		</c:when>
																	</c:choose>
																</c:forEach>
														</table>
													</div>
												</div>

											</div>

										</div>
									</div>
									<!--펀드선택-->
									<!-- 펀드바구니-->
									<div class="col-12" id="category02Section2">

										<div class="card top-selling overflow-auto">
											<div class="card-body">
												<h5 class="card-title">
													펀드바구니 <span id="fundRatio">|선택펀드비율: %</span>
												</h5>
												<span class="fund_ok">펀드를 선택해주세요</span> <span
													class="fundRatio_ok">펀드비율의 총합은 100%가 되어야 합니다.</span>
												<div class="tab-content pt-2" id="myTabContent">

													<!--  <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="profile-tab"> -->
													<table class="type09" id="selectedFund">
														<colgroup>
															<col style="width: 20%;" />
															<col style="width: 50%;" />
															<col style="width: 30%;" />
														</colgroup>
														<thead>
															<tr>
																<th scope="col">선택</th>
																<th scope="col">펀드명</th>
																<th scope="col">비율(%)</th>
															</tr>
														</thead>
														<tbody></tbody>

													</table>
													<!--  </div> -->
												</div>

											</div>

										</div>
									</div>

									<!--펀드바구니-->
								</div>
							</div>
							<!-- End Left side columns -->

							<!-- Right side columns -->
							<div class="col-lg-3">

								<!-- Recent Activity -->
								<div class="card">


									<div class="card-body">
										<h5 class="card-title">
											<b>가입고객</b><span>| 요약</span>
										</h5>

										<div class="activity">

											<div class="card-header"></div>
											<div class="card-body">
												<h5 class="card-title">
													<span>| 계약자 </span>
												</h5>
												<p class="card-text">${customerDTO.name}|

													<c:choose>
														<c:when test="${customerDTO.gender eq 'M'}">
																	남자
																	</c:when>
														<c:otherwise>
																	여자
																	</c:otherwise>
													</c:choose>
													|${customerDTO.age }세
												</p>

												<h5 class="card-title">
													<span>| 피보험자 </span>
												</h5>
												<p class="card-text">${customerDTO.name}|
													<input type="hidden" value="${customerDTO.id}"
														id="insurantId"> <input type="hidden"
														value="${customerDTO.gender }" id="insurantgender">
													<c:choose>
														<c:when test="${customerDTO.gender eq 'M'}">
																남자
														</c:when>
														<c:otherwise>
																		여자
														</c:otherwise>
													</c:choose>
													|${customerDTO.age }세 <input type="hidden"
														value="${customerDTO.age}" id="insurantage">
												</p>
											</div>
											<div class="card-header"></div>
											<div class="card-body">
												<h5 class="card-title">
													<span><b>| 합계보험료 </b></span>
												</h5>
												<p class="card-text" id="newPremium"></p>

												<h5 class="card-title">
													<span><b>| 상령시보험료확인 </b></span>
												</h5>
												<p class="card-text" id="incrementPremium"></p>
												<p class="card-text">
													<span class="badge bg-success">상령일</span>
													${customerDTO.plusMonthDay}
												</p>
												<div id="planContainer" data-plan-id="">
													<p>

														<button type="button" id="premCalc"
															class="btn btn-primary btn-sm">보험료계산</button>

														<button type="button" data-bs-toggle="modal" id="savePlan"
															data-bs-target="#basicModal"
															class="btn btn-primary btn-sm">저장/가입안내서</button>
														<button type="button" class="btn btn-primary btn-sm"
															data-bs-toggle="modal" data-bs-target="#ExtralargeModal"
															id="sumContractModal">기계약합산</button>
														<button type="button" class="btn btn-primary btn-sm"
															id="confirmContract">청약</button>
													</p>

												</div>
											</div>
										</div>
										<!-- End activity item-->
									</div>
								</div>
							</div>
							<!-- End Recent Activity -->
						</div>
						<!-- End sidebar recent posts-->

						<div class="modal fade" id="basicModal" tabindex="-1">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title">가입설계내용저장</h5>
										<button type="button" class="btn-close"
											data-bs-dismiss="modal" aria-label="Close"></button>
									</div>
									<div class="modal-body">
										<div class="row mb-3">
											<label for="inputText" class="col-sm-4 col-form-label">가입설계명</label>
											<div class="col-sm-8">
												<input type="text" class="form-control" id="subName"
													value="${customerDTO.name}의 ${productDTO.name}">
											</div>

											<label for="inputText" class="col-sm-4 col-form-label">설계FC</label>
											<div class="col-sm-8">
												<input type="text" class="form-control" value="${userName}"
													readonly>
											</div>
										</div>

									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary"
											data-bs-dismiss="modal">Close</button>
										<button type="button" class="btn btn-primary" id="savePlan1">가입설계저장</button>
									</div>
								</div>
							</div>
						</div>
						<!-- End Basic Modal-->


						<!-- 기계약합산 모달 -->
						<div class="modal fade" id="ExtralargeModal" tabindex="-1">
							<div class="modal-dialog modal-xl">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title">기계약합산</h5>
										<button type="button" class="btn-close"
											data-bs-dismiss="modal" aria-label="Close"></button>
									</div>
									<div class="modal-body">
										<div class="row mb-3">
											<label for="insurantId" class="col-sm-4 col-form-label">고객명</label>
											<div class="col-sm-8">${customerDTO.name}</div>
											<table class="type09">
												<thead style="text-align: center;">
													<tr>
														<th scope="col">심사분류명</th>
														<th scope="col">총한도금액(A)</th>
														<th scope="col">기계약금액(B)</th>
														<th scope="col">신계약금액(C)</th>
														<th scope="col">잔여한도금액(D)</th>
														<th scope="col">한도초과여부</th>
													</tr>
												</thead>
												<tbody id="sumContractList">
													<tr>
														<td scope="col" style="text-align: center;">암진단금</td>
														<td scope="col" style="text-align: right;"><span
															id="standardCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="oldCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="newCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="diffCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="limitCancerValue"></span></td>
													</tr>
													<tr>
														<td scope="col" style="text-align: center;">유사암진단금</td>
														<td scope="col" style="text-align: right;"><span
															id="standardPCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="oldPCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="newPCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="diffPCancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="limitPCancerValue"></span></td>
													</tr>
													<tr>
														<td scope="col" style="text-align: center;">고액암진단금</td>
														<td scope="col" style="text-align: right;"><span
															id="standardECancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="oldECancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="newECancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="diffECancerValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="limitECancerValue"></span></td>
													</tr>
													<tr>
														<td scope="col" style="text-align: center;">일반사망보험금</td>
														<td scope="col" style="text-align: right;"><span
															id="standardGDeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="oldGDeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="newGDeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="diffGDeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="limitGDeathValue"></span></td>
													</tr>
													<tr>
														<td scope="col" style="text-align: center;">재해사망보험금</td>
														<td scope="col" style="text-align: right;"><span
															id="standardADeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="oldADeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="newADeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="diffADeathValue"></span></td>
														<td scope="col" style="text-align: right;"><span
															id="limitADeathValue"></span></td>
													</tr>
												</tbody>
											</table>
										</div>

									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary"
											data-bs-dismiss="modal">취소(재설계)</button>
										<button type="button" class="btn btn-primary" id="sumOk">기계약합산OK</button>
										<span id="result" style="display: none;"></span>

									</div>
								</div>
							</div>
						</div>

						<!-- End ExtralargeModal Modal-->
						<!-- 모달 코드 -->

						<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
							aria-labelledby="myModalLabel">
							<div class="modal-dialog modal-xl" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title" id="myModalLabel">가입설계서</h4>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">
										<!-- 내용 -->
										<div id="page1" class="page">
											<br>
											<div class="text-center" style="width: 100%;">
												<img src="<c:url value='/resources/img/mirae.jpg'/>"
													alt="Image" style="width: 100%; height: auto;">
											</div>

											<br>
											<!-- <h2>
             <strong>가입설계서</strong>
          </h2> -->
											<h3>
												<br> <strong>${productDTO.name}</strong>
											</h3>
											<br>
											<h4>
												<span id="insurantName1"></span>님을 위한 가입안내서
											</h4>

											<br>
											<div class="text-center" style="width: 100%;">
												<img src="<c:url value='/resources/img/money.jpg'/>"
													alt="Image" style="width: 100%; height: auto;">
											</div>
											<br> <br>

											<!-- FC 정보 -->
											<div class="table-responsive">
												<table class="table table-bordered">
													<thead style="text-align: center;">
														<tr>
															<th>항목</th>
															<th>내용</th>
														</tr>
													</thead>
													<tbody style="text-align: center;">
														<tr>
															<td>FC</td>
															<td id="fcName"></td>
														</tr>
														<tr>
															<td>대리점명</td>
															<td id="fcAgency"></td>
														</tr>
														<tr>
															<td>Email</td>
															<td id="fcEmail"></td>
														</tr>
														<tr>
															<td>가입설계일</td>
															<td id="planDay"></td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
										<div id="page2" class="page">
											<br>
											<h2>
												<strong>보험계약의 개요</strong>
											</h2>
											<br>
											<div class="text-center" style="width: 100%;">
												<img src="<c:url value='/resources/img/checklist.jpg'/>"
													alt="Image" style="width: 100%; height: 250px;">
											</div>

											<br>
											<table class="table table-bordered"
												style="text-align: center;">
												<thead>
													<tr>
														<th>항목</th>
														<th>내용</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>보험상품명</td>
														<td id="productName"></td>
													</tr>
													<tr>
														<td>주피보험자</td>
														<td id="insurantName2"></td>
													</tr>
												</tbody>
											</table>

											<br>
											<table class="table table-bordered"
												style="text-align: center;">
												<thead>
													<tr>
														<th>보험종류</th>
														<th>피보험자</th>
														<th>보험가입금액</th>
														<th>가입나이</th>
														<th>보험기간</th>
														<th>납입기간</th>
														<th>납입주기</th>
														<th>보험료(원)</th>
													</tr>
												</thead>
												<tbody id="groupedOptionsTableBody">
													<!-- JavaScript에서 동적으로 데이터가 삽입됨 -->
												</tbody>
											</table>
											<br>
											<div id="fundTableContainer">
												<!-- JavaScript를 통해 테이블이 동적으로 삽입 -->
											</div>
										</div>

										<div id="page3" class="page">
											<br>
											<h2>
												<strong>해약환급금 관련 안내</strong>
											</h2>
											<br>

											<c:choose>
												<c:when test="${productDTO.id eq 'A10'}">
													<div class="table-responsive" style="overflow-y: visible;">
														<div>
															<table id="tableA10"
																class="table table-bordered table-hover"
																style="text-align: center;">
																<thead class="thead-dark">
																	<tr>
																		<th>경과년도(년)</th>
																		<th>주피나이(세)</th>
																		<th>실납입보험료(원)</th>
																		<th>환급금(원)</th>
																		<th>환급률(%)</th>
																	</tr>
																</thead>
																<tbody>
																	<!-- 테이블 내용은 JavaScript로 동적으로 생성 -->
																</tbody>
															</table>
														</div>
													</div>
												</c:when>
											</c:choose>

											<c:choose>
												<c:when test="${productDTO.id eq 'A20'}">
													<div class="table-responsive" style="overflow-y: visible;">
														<div>
															<table id="tableA20"
																class="table table-bordered table-hover">
																<thead class="thead-dark" style="text-align: center;">
																	<tr>
																		<th>경과년도(년)</th>
																		<th>주피나이(세)</th>
																		<th>실납입보험료(원)</th>
																		<th>환급금(원)</th>
																		<th>환급률(%)2.25%가정(순수익률2.22%)</th>
																	</tr>
																</thead>
																<tbody style="text-align: right;">
																	<!-- 테이블 내용은 JavaScript로 동적으로 생성 -->
																</tbody>
															</table>
														</div>
													</div>
												</c:when>
											</c:choose>
											<div class="modal-footer">
												<button type="button" class="btn btn-secondary"
													data-dismiss="modal">닫기</button>
												<button id="savePdfButton" class="btn btn-primary">PDF로
													저장</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 가입설계서모달  -->
					</section>

				</main>
				<!-- End #main -->

				<!-- ======= Footer ======= -->
				<footer id="footer" class="footer">
					<div class="copyright">
						&copy; Copyright <strong><span>Ztop</span></strong>. All Rights
						Reserved
					</div>
				</footer>


				<!--     만족도조사모달 -->
				<sec:authorize access="isAuthenticated()">
					<div class="modal fade" id="opinionModal" tabindex="-1">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title">
										<b>ZTOP이 도움이 되셨나요?</b>
									</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal"
										aria-label="Close"></button>
								</div>
								<div class="modal-body">
									<div class="row mb-3">
										<div class="star-rating space-x-4 mx-auto">
											<div id="emoji" style="font-size: 2rem;"></div>
											<input type="radio" id="5-stars" name="rating" value="5"
												onclick="updateRating(5)" /> <label for="5-stars"
												class="star pr-4">★</label> <input type="radio" id="4-stars"
												name="rating" value="4" onclick="updateRating(4)" /> <label
												for="4-stars" class="star">★</label> <input type="radio"
												id="3-stars" name="rating" value="3"
												onclick="updateRating(3)" /> <label for="3-stars"
												class="star">★</label> <input type="radio" id="2-stars"
												name="rating" value="2" onclick="updateRating(2)" /> <label
												for="2-stars" class="star">★</label> <input type="radio"
												id="1-star" name="rating" value="1"
												onclick="updateRating(1)" /> <label for="1-star"
												class="star">★</label>
										</div>

										<div class="col-sm-8" id="reviewText">
											<textarea rows="5" id="reviewContents"
												placeholder="(선택사항)&#10;FC님의 소중한 의견으로 더 나은 ZTOP이 되겠습니다."></textarea>
											<p id="result"></p>
										</div>

									</div>

								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal" id="modallogout">나중에할래요!</button>
									<button type="button" class="btn btn-primary" id="saveOpinion">리뷰등록후로그아웃</button>
								</div>
							</div>
						</div>
					</div>
				</sec:authorize>
				<!--     만족도조사모달 -->


				<script src="/resources/js/main.js"></script>
				<script src="/resources/js/contract/makePlan.js"></script>

				<!------------------------------- 화면 그리드 ------------------------------->
			</div>
		</div>
		<div class="grid-item right">
			<img src="/resources/img/gridRm.jpg">
		</div>
		<div class="grid-item bottom">
			<img src="/resources/img/gridBm.jpg">
		</div>
	</div>
	<!------------------------------- 화면 그리드 ------------------------------->
</body>

</html>