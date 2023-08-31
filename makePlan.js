$(document).ready(function() {
	showCategory();
});

let showCategory = function() {
	var category = $('#productCategory').val();
	if (category === '01') {
		$('#category01Section').show();
		$('#category01Section2').show();
		$('#category02Section').hide();
		$('#category02Section2').hide();
	} else {

		$('#category02Section').show();
		$('#category02Section2').show();
		$('#category01Section').hide();
		$('#category01Section2').hide();
	}
};

$('#selectOpt').on('click', '.moveable input[type="checkbox"]', function() {
	var tr = $(this).closest('tr');
	$('#selectedOpt').append(tr);
});

$('#selectedOpt').on('click', 'input[type="checkbox"]', function() {
	var tr = $(this).closest('tr');
	$('#selectOpt').append(tr);
});



var sum = 0;
$('#selectFund1 input[type="checkbox"], #selectFund2 input[type="checkbox"], #selectFund3 input[type="checkbox"]').change(function() {

	if (this.checked) {
		var tr = $(this).closest('tr');
		var selectedRatio = parseInt(tr.find('td:eq(2)').find('input[type="text"]').val());

		if (selectedRatio === 0 || isNaN(selectedRatio) || selectedRatio === null) {
			Swal.fire({
				title: '선택펀드의 비율(%)을 \n입력해주시기 바랍니다.',
				icon: 'warning'
			});
			$(this).prop('checked', false);
			return;
		}




		// 새로 선택한 펀드의 비율을 합계에 더하고, 100을 초과하지 않는지 확인합니다.
		sum += selectedRatio;
		if (sum <= 100) {
			$('#selectedFund').append(tr);
			updateSelectedFundRatio();
		} else {
			Swal.fire({
				title: '펀드비율의 총합은 \n 100%를 넘을 수 없습니다.',
				icon: 'warning'
			})

			$(this).prop('checked', false); // 체크박스의 선택을 취소합니다.
		}
	}
});

$('#selectedFund').on('click', 'input[type="checkbox"]', function() {
	var tr = $(this).closest('tr');
	var selectedRatio = parseInt(tr.find('td:eq(2)').find('input[type="text"]').val());
	sum -= selectedRatio;
	updateSelectedFundRatio();
	$('#selectFund1').append(tr);
	$(this).prop('checked', false);
});

$('#selectedFund').on('change', 'tr', updateSelectedFundRatio);




/*보험료계산/저장/기계약합산/청약 버튼컨트롤*/
$("#planContainer button").prop("disabled", true);
$("#premCalc").prop("disabled", false);


function checkTotalRatio() {
	let totalRatio = parseInt($('#fundRatio').text().replace("선택펀드비율: ", "").replace("%", ""));
	if (totalRatio !== 100) {
		$('.fundRatio_ok').css("display", "inline-block");
	} else {
		$('.fundRatio_ok').css("display", "none");
	}
}

function updateSelectedFundRatio() {
	$('#fundRatio').text("선택펀드비율: " + sum + "%");
	checkTotalRatio();
}


/* 특약별 실시간 보험료 계산 */
$('select, input[type=text].optAmount').on('change', function() {

	var $tr = $(this).closest('tr');
	var iTerm = $(this).closest('tr').find('select:eq(0)').val();
	var payTerm = $(this).closest('tr').find('select:eq(1)').val();
	var payCycle = $(this).closest('tr').find('select:eq(2)').val();
	var amount = Number.parseInt($(this).closest('tr').find('input[type=text]').val().replaceAll(",", "")) * 10000;
	var insuranceOptionKey = $(this).closest('tr').find('td:eq(1)').text();
	var insurantage = $('#insurantage').val(); // 추가
	var insurantgender = $('#insurantgender').val(); // 추가  
	var minA = Number($(this).closest('tr').find('#optMinA').val()) * 10000;
	var maxA = Number($(this).closest('tr').find('#optMaxA').val()) * 10000;

	if (amount < minA || amount > maxA) {

		$tr.find('.minmax_ok').css("display", "inline-block");
	}

	if (amount >= minA && amount <= maxA) {
		$tr.find('.minmax_ok').css("display", "none");
	}

	// AJAX 요청
	$.ajax({
		url: '/contract/premCalc',
		type: 'POST',
		data: {
			'payTerm': payTerm, // 선택된 "payTerm" 값
			'payCycle': payCycle, // 선택된 "payCycle" 값
			'iTerm': iTerm, // 선택된 "iTerm" 값
			'amount': amount, // 입력된 가입금액
			'optName': insuranceOptionKey, // 관련된 특약명
			'joinAge': insurantage, // 추가
			'gender': insurantgender
			// 추가  
		},
		success: (resp) => {
			let obj = JSON.parse(resp);
			var newPremium = obj.result;


			$tr.find('.optAmount').val(addCommasToNumber(amount / 10000));
			$tr.find('.optPremium').val(addCommasToNumber(newPremium));

		}
	});
});

/* 전체보험료계산 */
$('#premCalc').click(function() {
	var isOutofRange = false;
	var isZero = false;
	var isMainOutofRange = false;

	var category = $('#productCategory').val();


	if (category == "01") {

		var rowData = [];
		var insurantage = $('#insurantage').val();
		var insurantgender = $('#insurantgender').val();

		var optName = $("#mainTable td:eq(0)").text(); // 주계약명         
		var joinAmount = Number.parseInt($("#mainTable td:eq(2)").find('input[type=text]').val().replaceAll(",", "")) * 10000; // 가입금액
		var payTerm = $("#mainTable td:eq(4)").find('select').val(); // 납입기간
		var iTerm = $("#mainTable td:eq(5)").find('select').val(); // 보험기간
		var payCycle = $("#mainTable td:eq(6)").find('select').val(); // 납입주기
		var mainMinA = Number($('#mainMinA').val()) * 10000;
		var mainMaxA = Number($('#mainMaxA').val()) * 10000;


		if (joinAmount == 0) {

			$('.id_already').css("display", "inline-block");
			isZero = true;

		} else {
			$('.id_already').css("display", "none");

		}

		if (joinAmount < mainMinA || joinAmount > mainMaxA) {
			$('.mainminmax_ok').css("display", "inline-block");
			isMainOutofRange = true;
		}

		if (joinAmount >= mainMinA && joinAmount <= mainMaxA) {
			$('.mainminmax_ok').css("display", "none");

		}

		$('#selectedOpt tr').each(function(index) {
			if (index != 0) {
				var row = $(this);
				var iTermRow = row.find('select:eq(0)').val();
				var payTermRow = row.find('select:eq(1)').val();
				var payCycleRow = row.find('select:eq(2)').val();

				var amount = Number.parseInt($(this).closest('tr').find('input[type=text]').val().replaceAll(",", "")) * 10000;
				var insuranceOptionKey = row.find('td:eq(1)').text();
				var insurantage = $('#insurantage').val();
				var insurantgender = $('#insurantgender').val();
				var minA = Number($('#optMinA').val()) * 10000;
				var maxA = Number($('#optMaxA').val()) * 10000;

				let data = {
					'payTerm': payTermRow,
					'payCycle': payCycleRow,
					'iTerm': iTermRow,
					'amount': amount,//
					'optName': insuranceOptionKey,//
					'joinAge': insurantage,//
					'gender': insurantgender//
				}

				rowData.push(data);

				if (amount < minA || amount > maxA) {

					row.find('.minmax_ok').css("display", "inline-block");
					isOutofRange = true;
				}

				if (amount >= minA && amount <= maxA) {

					row.find('.minmax_ok').css("display", "none");

				}
			}
		});



		let optList = JSON.stringify(rowData)
		$.ajax({
			url: '/contract/totalPremCalc',
			type: 'POST',
			data: {

				'rowData': optList,
				'amount': joinAmount,
				'payTerm': payTerm,
				'iTerm': iTerm,
				'payCycle': payCycle,
				'joinAge': insurantage,
				'gender': insurantgender,
				'optName': optName
			},
			success: (resp) => {

				let obj = JSON.parse(resp);

				var newPremium = obj.result;


				$('#newPremium').text(addCommasToNumber(newPremium) + ' 원');                            // 보험료 input 업데이트
				var mainPremium = obj.mainPremium;

				$('#mainPremium').val(addCommasToNumber(mainPremium));

				var incrementPremium = obj.newresult;

				$('#incrementPremium').text(addCommasToNumber(incrementPremium) + ' 원');

				$('#number').val(addCommasToNumber(joinAmount / 10000));
				if (newPremium > 0 && !isOutofRange && !isZero && !isMainOutofRange) {
					$("#savePlan").prop("disabled", false);
					$("#sumContractModal").prop("disabled", true);
					$("#confirmContract").prop("disabled", true);
				} else {
					$("#savePlan").prop("disabled", true);
					$("#sumContractModal").prop("disabled", true);
					$("#confirmContract").prop("disabled", true);
				}
			}
		});
	}
	else if (category === '02') {
		var payTerm = $("#mainTable td:eq(4)").find('select').val(); // 납입기간
		var premium = Number.parseInt($('#variblePremium').val().replaceAll(",", "")); // 보험료
		var mainMinA = $('#mainMinA').val();
		var mainMaxA = $('#mainMaxA').val();

		var joinAmount = (payTerm * premium * 12) / 10000;


		if (joinAmount < mainMinA || joinAmount > mainMaxA) {
			$('.mainminmax_ok').css("display", "inline-block");
			isMainOutofRange = true;
		}

		if (joinAmount >= mainMinA && joinAmount <= mainMaxA) {
			$('.mainminmax_ok').css("display", "none");

		}
		checkjoinPremium(premium);
		$('#varibleAmount').val(joinAmount);
		$('#newPremium').text(premium + ' 원');


		if (premium > 0 && !isZero && !isMainOutofRange && sum >= 100) {

			$("#savePlan").prop("disabled", false);
			$("#sumContractModal").prop("disabled", true);
			$("#confirmContract").prop("disabled", true);
		} else {
			$("#savePlan").prop("disabled", true);
			$("#sumContractModal").prop("disabled", true);
			$("#confirmContract").prop("disabled", true);
		}



	}
});


/* 가입설계서 저장 */
$('#savePlan1').click(function() {

	var category = $('#productCategory').val();

	if (category === '01') {
		var mainPremium = Number.parseInt($('#mainPremium').val().replaceAll(",", ""));


	} else if (category === '02') {
		var mainPremium = Number.parseInt($('#variblePremium').val().replaceAll(",", ""));
	}

	var rowData = [];
	var fundData = [];


	var optName = $("#mainTable td:eq(0)").text().trim(); // 주계약명
	var joinAmount = Number.parseInt($("#mainTable td:eq(2)").find('input[type=text]').val().replaceAll(",", "")) * 10000; // 가입금액

	var payTerm = $("#mainTable td:eq(4)").find('select').val(); // 납입기간
	var iTerm = $("#mainTable td:eq(5)").find('select').val(); // 보험기간
	var payCycle = $("#mainTable td:eq(6)").find('select').val(); // 납입주기

	var insurantage = $('#insurantage').val();
	var insurantgender = $('#insurantgender').val();
	var insurantId = $('#insurantId').val();
	var insurantId = $('#insurantId').val();
	var TotalPremium = Number.parseInt($('#newPremium').text().replace(/,/g, '').replace(' 원', ''));


	var productId = $('#productId').val();
	var subName = $('#subName').val();


	/* 특약바구니 시작*/
	$('#selectedOpt tr').each(function(index) {
		if (index != 0) {
			var row = $(this);
			var iTermRow = row.find('select:eq(0)').val();
			var payTermRow = row.find('select:eq(1)').val();
			var payCycleRow = row.find('select:eq(2)').val();
			var amount = Number.parseInt($(this).closest('tr').find('.optAmount').val().replaceAll(",", "")) * 10000;   // 가입금액
			var insuranceOptionKey = row.find('td:eq(1)').text();
			var insurantage = $('#insurantage').val();
			var insurantgender = $('#insurantgender').val();
			var premium = Number.parseInt(row.find('.optPremium').val().replaceAll(",", ""));

			var insurantId = $('#insurantId').val();


			let data = {
				'payTerm': payTermRow,
				'payCycle': payCycleRow,
				'iTerm': iTermRow,
				'amount': amount,
				'optName': insuranceOptionKey,
				'joinAge': insurantage,
				'gender': insurantgender,
				'premium': premium,
				'insurantId': insurantId,

			}
			rowData.push(data);
		}
	});
	let optList = JSON.stringify(rowData)
	/* 특약바구니 끝*/


	/* 펀드바구니 시작 */
	$('#selectedFund tr').each(function(index) {
		if (index != 0) {
			var row = $(this);
			var fundNameRow = $(this).find('td:eq(1)').find('input[type="hidden"]').val();
			var ratioRow = parseInt($(this).find('td:eq(2)').find('input[type="text"]').val());

			let data = {
				'fundId': fundNameRow,
				'fundratio': ratioRow,
			}
			fundData.push(data);
		}
	});

	let fundList = JSON.stringify(fundData)

	/* 펀드바구니 끝 */


	$.ajax({
		url: '/contract/savePlan',

		type: 'POST',
		data: {

			'rowData': optList,
			'amount': joinAmount,
			'payTerm': payTerm,
			'iTerm': iTerm,
			'payCycle': payCycle,
			'joinAge': insurantage,
			'gender': insurantgender,
			'optName': optName,
			'insurantId': insurantId,
			'mainPremium': mainPremium,
			'productId': productId,
			'subName': subName,
			'tPremium': TotalPremium,
			'fundData': fundList
		},
		success: (resp) => {

			let obj = JSON.parse(resp);
			var newPlanId = obj.newPlanId;

			$("#planContainer").attr("data-plan-id", newPlanId);

			if (newPlanId > 0) {
				$("#sumContractModal").prop("disabled", false);
				$("#confirmContract").prop("disabled", true);
			} else {
				$("#sumContractModal").prop("disabled", true);
				$("#confirmContract").prop("disabled", true);
			}
			viewSavedPlan(newPlanId);
			$("#myModal").modal("show");

		}
	});
});



$(".close, .btn-secondary").click(function() {
	// 모달을 닫습니다.
	$("#myModal").modal('hide');
	$("#basicModal").modal('hide');
	// 필드 내용을 초기화합니다.
	$("#someInputField").val('');
});


$("#savePdfButton").click(function() {
	const pdf = new jspdf.jsPDF({
		orientation: 'portrait',
		unit: 'mm',
		format: 'a4'
	});

	const pages = document.querySelectorAll('.page');
	let currentPage = 0;

	function capturePageAndAdd() {
		// 버튼의 visibility를 hidden으로 설정
		const modalFooterButtons = document.querySelectorAll('.modal-footer .btn');
		modalFooterButtons.forEach(button => {
			button.style.visibility = 'hidden';
		});

		html2canvas(pages[currentPage], {
			scale: 1,
		}).then(canvas => {
			// 버튼의 visibility를 다시 visible로 설정
			modalFooterButtons.forEach(button => {
				button.style.visibility = 'visible';
			});

			const imgData = canvas.toDataURL('image/png');
			const imgWidth = 210;
			const imgHeight = canvas.height * imgWidth / canvas.width;

			if (currentPage > 0) {
				pdf.addPage();
			}

			pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);

			if (currentPage < pages.length - 1) {
				currentPage++;
				capturePageAndAdd();
			} else {
				pdf.save("가입설계서.pdf");
			}
		});
	}
	capturePageAndAdd();
});


$('#confirmContract').click(function() {
	var newPlanId = $("#planContainer").attr("data-plan-id");
	if (newPlanId !== "") {
		window.location.href = '/contract/confirmContract/' + newPlanId;
	} else {
		console.warn('newPlanId is not set.');
	}
});


$('#sumContractModal').click(function() {
	var planId = $("#planContainer").attr("data-plan-id");

	$.ajax({
		url: '/contract/sumContract/' + planId,
		type: 'GET',

		success: (resp) => {
			let obj = JSON.parse(resp);


			var standardCancer = obj.standardCancer;
			var standardECancer = obj.standardECancer;
			var standardPCancer = obj.standardPCancer;
			var standardADeath = obj.standardADeath;
			var standardGDeath = obj.standardGDeath;

			var newCancer = obj.newCancer;
			var newECancer = obj.newECancer;
			var newPCancer = obj.newPCancer;
			var newADeath = obj.newADeath;
			var newGDeath = obj.newGDeath;

			var oldCancer = obj.oldCancer;
			var oldECancer = obj.oldECancer;
			var oldPCancer = obj.oldPCancer;
			var oldADeath = obj.oldADeath;
			var oldGDeath = obj.oldGDeath;

			var diffCancer = standardCancer - oldCancer - newCancer;
			var diffECancer = standardECancer - oldECancer - newECancer;
			var diffPCancer = standardPCancer - oldPCancer - newPCancer;
			var diffADeath = standardADeath - oldADeath - newADeath;
			var diffGDeath = standardGDeath - oldGDeath - newGDeath;

			let result = false;
			if (diffCancer < 0) {
				var limitCancer = "한도초과";
				result = true;
			} else { var limitCancer = "가입가능"; }
			if (diffECancer < 0) {
				var limitECancer = "한도초과";
				result = true;
			} else { var limitECancer = "가입가능"; }
			if (diffPCancer < 0) {
				var limitPCancer = "한도초과";
				result = true;
			} else { var limitPCancer = "가입가능"; }
			if (diffADeath < 0) {
				var limitADeath = "한도초과";
				result = true;
			} else { var limitADeath = "가입가능"; }
			if (diffGDeath < 0) {
				var limitGDeath = "한도초과";
				result = true;
			} else { var limitGDeath = "가입가능"; }


			$('#standardCancerValue').text(addCommasToNumber(standardCancer));
			$('#standardECancerValue').text(addCommasToNumber(standardECancer));
			$('#standardPCancerValue').text(addCommasToNumber(standardPCancer));
			$('#standardADeathValue').text(addCommasToNumber(standardADeath));
			$('#standardGDeathValue').text(addCommasToNumber(standardGDeath));

			$('#newCancerValue').text(addCommasToNumber(newCancer));
			$('#newECancerValue').text(addCommasToNumber(newECancer));
			$('#newPCancerValue').text(addCommasToNumber(newPCancer));
			$('#newADeathValue').text(addCommasToNumber(newADeath));
			$('#newGDeathValue').text(addCommasToNumber(newGDeath));

			$('#oldCancerValue').text(addCommasToNumber(oldCancer));
			$('#oldECancerValue').text(addCommasToNumber(oldECancer));
			$('#oldPCancerValue').text(addCommasToNumber(oldPCancer));
			$('#oldADeathValue').text(addCommasToNumber(oldADeath));
			$('#oldGDeathValue').text(addCommasToNumber(oldGDeath));

			$('#diffCancerValue').text(addCommasToNumber(diffCancer));
			$('#diffECancerValue').text(addCommasToNumber(diffECancer));
			$('#diffPCancerValue').text(addCommasToNumber(diffPCancer));
			$('#diffADeathValue').text(addCommasToNumber(diffADeath));
			$('#diffGDeathValue').text(addCommasToNumber(diffGDeath));

			$('#limitCancerValue').text(addCommasToNumber(limitCancer));
			$('#limitECancerValue').text(addCommasToNumber(limitECancer));
			$('#limitPCancerValue').text(addCommasToNumber(limitPCancer));
			$('#limitADeathValue').text(addCommasToNumber(limitADeath));
			$('#limitGDeathValue').text(addCommasToNumber(limitGDeath));

			$('#result').text(result);
			/*$('#sumContractModal').modal('show');*/
		}, error: (e) => {
			console.log(e)
		}


	});
});


$("#sumOk").click(function() {
	var result = $("#result").text();
	var planId = $("#planContainer").attr("data-plan-id");
	if (result === "true") {
		//alert("한도초과입니다. 가입금액 확인해주세요");    
		Swal.fire({
			title: '한도초과입니다. 가입금액 확인해주세요',
			icon: 'warning'
		});


	} else {
		processSumContract(planId);
	}
});


/* 계약상태 변경하러 고고 */
function processSumContract(planId) {
	$.ajax({

		url: '/contract/sumContract/' + planId,
		type: 'POST',
		success: function() {
			Swal.fire({
				title: '기계약합산 OK!  청약진행 가능합니다',
				icon: 'success',
				showCancelButton: true,
				confirmButtonText: '청약',
				cancelButtonText: '확인'
			}).then(result => {
				if (result.isConfirmed) {
					location.href = '/contract/confirmContract/' + planId;
				} else if (result.isDismissed) {
					/*top.window.close();*/
					$('#ExtralargeModal').modal('hide');
					$("#confirmContract").prop("disabled", false);


				}
			});
		},

		error: (e) => {
			console.log(e)
		}
	});

}

/*민정추가*/
function viewSavedPlan(newPlanId) {
	$.ajax({
		url: '/contract/viewSavedPlan/' + newPlanId,
		type: 'GET',
		data: { 'planId': newPlanId },
		success: (resp) => {
			try {
				let obj = JSON.parse(resp);
				var logIn = obj.logIn;
				var contractDTO = obj.contractDTO;
				var contractOptList = obj.contractOptList;
				var groupedOptions = obj.groupedOptions;
				var premiumInfoList = obj.premiumInfoList;
				var productDTO = obj.productDTO;
				var contractorName = obj.contractorName;
				var insurantName = obj.insurantName;
				var insurantNum = obj.insurantNum;
				var insurantAge = obj.insurantAge;
				var insurantGender = obj.insurantGender;
				var fcCode = obj.fcCode;
				var fcName = obj.fcName;
				var fcAgency = obj.fcAgency;
				var contractFundList = obj.contractFundList;

				// Update the UI elements with the received data
				$('#fcName').text(logIn.name);
				$('#fcAgency').text(logIn.agency);
				$('#fcEmail').text(logIn.email);
				$('#contractorName').text(contractorName);
				$('#insurantName1').text(insurantName);
				$('#insurantName2').text(insurantName);
				$('#insurantNum').text(insurantNum);
				$('#insurantAge').text(insurantAge);
				$('#insurantGender').text(insurantGender);
				$('#fcCode').text(fcCode);
				$('#contractId').text(contractDTO.id);
				$('#productId').text(contractDTO.productId);
				$('#contractorId').text(contractDTO.contractorId);
				$('#insurantId').text(contractDTO.insurantId);


				var planDate = new Date(contractDTO.planDay);
				var formattedDate = planDate.getFullYear() + '-' +
					(planDate.getMonth() + 1).toString().padStart(2, '0') + '-' +
					planDate.getDate().toString().padStart(2, '0');
				$('#planDay').text(formattedDate);
				$('#productName').text(productDTO.name);
				$('#productPrice').text(productDTO.price);

				$('#premiumInfo').empty();
				premiumInfoList.forEach(premium => {
					$('#premiumInfo').append(`

                    <tr>
                        <td>${premium.optionId}</td>
                        <td>${premium.joinAge}</td>
                        <td>${premium.gender}</td>
                        <td>${premium.payTerm}</td>
                        <td>${premium.ITerm}</td>
                        <td>${premium.refund}</td>
                    </tr>
                    `);
				});

				if (productDTO.id === 'A20' && contractFundList && contractFundList.length > 0) {
					var table = $("<table></table>").addClass("table table-bordered");
					var thead = $("<thead></thead>");
					var tbody = $("<tbody></tbody>");

					thead.append(`
                        <tr>
                           <th>펀드명</th>
                           <th>펀드비율</th>
                        </tr>
                    `);

					contractFundList.forEach(fund => {
						tbody.append(`
                            <tr>
                               <td>${fund.fund.name}</td>
                               <td>${fund.fundRatio}%</td>
                            </tr>
                        `);

					});

					table.append(thead);
					table.append(tbody);

					$('#fundTableContainer').append(table);
				}

				// groupedOptions 데이터를 동적으로 처리
				$('#groupedOptionsTableBody').empty();
				let uniqueCheck = {};
				for (var optionId in groupedOptions) {
					if (groupedOptions.hasOwnProperty(optionId)) {
						var groupedOptionDataList = groupedOptions[optionId];
						var firstGroupedOptionData = groupedOptionDataList[0]; // 첫 번째 데이터만 가져오기
						let key = JSON.stringify(firstGroupedOptionData);
						if (!uniqueCheck[key]) {
							uniqueCheck[key] = 1;

							var newRow = $(`

                                <tr>
                                  <td>${firstGroupedOptionData.optName}</td>
                                  <td>${insurantName}</td>
                                  <td>${addCommasToNumber(firstGroupedOptionData.amount)}</td>
                                  <td>${insurantAge}</td>
                                  <td>${firstGroupedOptionData.iterm}</td> 
                                  <td>${firstGroupedOptionData.payTerm}</td>
                                  <td>${contractDTO.payCycle}(월납)</td>
                                  <td>${addCommasToNumber(firstGroupedOptionData.premium)}</td>
                               </tr>
                           `);
							$('#groupedOptionsTableBody').append(newRow);

							// 데이터 출력

						} else {
							console.warn("중복 데이터:", firstGroupedOptionData);
							uniqueCheck[key]++;
						}
					}
				}


				// 총보험료 합계 행을 추가
				var totalRow = $(`

                    <tr class="table-info">
                        <td colspan="7" class="text-right"><strong>총보험료 합계</strong></td>
                        <td>${addCommasToNumber(contractDTO.tpremium)}</td>
                    </tr>
                `);
				$('#groupedOptionsTableBody').append(totalRow);

				// 환급 정보를 테이블에 추가하는 부분
				var tableBodyA10 = $('#tableA10 tbody');
				addRefundInfoToTable(tableBodyA10, premiumInfoList, contractDTO, contractOptList, insurantAge, insurantGender);

				var tableBodyA20 = $('#tableA20 tbody');
				addRefundInfoToTable(tableBodyA20, premiumInfoList, contractDTO, contractOptList, insurantAge, insurantGender);

			} catch (error) {
				console.error(error);
				alert('데이터 처리 중 오류가 발생했습니다.');
			}
		},
		error: (e) => {
			console.error(e);
			alert('계획을 불러오는 데 실패했습니다. 나중에 다시 시도해 주세요.');
		}
	});
}

function addRefundInfoToTable(tableBody, premiumInfoList, contractDTO, contractOptList, insurantAge, insurantGender) {

	tableBody.empty();

	for (var passingYear = 1; passingYear <= contractDTO.payTerm; passingYear++) {
		var refundSumForYear = 0;
		var processedOptionIds = [];

		for (var i = 0; i < premiumInfoList.length; i++) {
			var premiumInfo = premiumInfoList[i];



			for (var j = 0; j < contractOptList.length; j++) {
				var contractOpt = contractOptList[j];

				var conditionsMet = premiumInfo.joinAge === insurantAge + passingYear &&
					premiumInfo.gender === insurantGender &&
					premiumInfo.payTerm === contractOpt.payTerm &&
					premiumInfo.ITerm === contractOpt.ITerm &&
					!processedOptionIds.includes(premiumInfo.optionId);
				//수정
				if (conditionsMet) {
					if (contractDTO.productId === "A10") {
						var refund = premiumInfo.standardA !== 0 ? contractOpt.amount * premiumInfo.refund / premiumInfo.standardA : 0;

						refundSumForYear += parseInt(refund);
					} else if (contractDTO.productId === "A20") {
						refundSumForYear += premiumInfo.refund;
					}
					processedOptionIds.push(premiumInfo.optionId);
				}


			}
		}

		var passingTpremium = contractDTO.tpremium * 12 * passingYear;
		var passingRefund = refundSumForYear === 0 ? '0' : ((refundSumForYear / passingTpremium) * 100).toFixed(1);
		var row = `

            <tr>
                <td>${passingYear}</td>
                <td>${insurantAge + passingYear}</td>
                <td>${addCommasToNumber(passingTpremium)}</td>
                <td>${addCommasToNumber(refundSumForYear)}</td>
                <td>${addCommasToNumber(passingRefund) + '%'}</td>
            </tr>
        `;
		tableBody.append(row);
	}
}



function checkjoinPremium(premium) {


	if (premium == 0) {

		$('.variblePremium_ok').css("display", "inline-block");

	} else {
		$('.variblePremium_ok').css("display", "none");


	}

}

function checkFund(totalRatio) {


	if (totalRatio < 100) {

		$('.fund_ok').css("display", "inline-block");

	} else {
		$('.fund_ok').css("display", "none");


	}

}

/*//세자리마다 ',' 찍기 
const input = document.querySelector('#number');

input.addEventListener('keyup', function(e) {
	let value = e.target.value;
	value = Number(value.replaceAll(',', ''));  //숫자로 변환
	const formatValue = value.toLocaleString('ko-KR');   //toLocaleString는 숫자를 입력받아야 한다.
	input.value = formatValue;

});*/

const inputs = document.querySelectorAll('.number-input', '.optPremium', '.optAmount');

inputs.forEach(input => {
	input.addEventListener('keyup', function(e) {
		let value = e.target.value;
		value = Number(value.replaceAll(',', ''));  // 숫자로 변환
		const formatValue = value.toLocaleString('ko-KR');   // toLocaleString는 숫자를 입력받아야 한다.
		input.value = formatValue;
	});
});

// 숫자에 세 자리마다 쉼표 추가하는 함수
function addCommasToNumber(number) {

	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


//});

