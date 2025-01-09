// chart.js
const xMileageMin = 0;
const xMileageMax = 200_000;
const mileageStep = 1000;

function low_mileage(x) {
    if (x >= 0 && x <= 50_000) {
        return 1;
    } else if (x > 50_000 && x <= 100_000) {
        return 1 - (x - 50_000) / 50_000;
    } else if (x > 100_000 && x <= 200_000) {
        return 0;
    }

    return null;
}

function medium_mileage(x) {
    if (x >= 0 && x <= 70_000) {
        return 0;
    } else if (x > 70_000 && x <= 110_000) {
        return (x - 70_000) / 40_000;
    } else if (x >= 110_000 && x <= 130_000) {
        return 1;
    } else if (x > 130_000 && x < 170_000) {
        return 1 - (x - 130_000) / 40_000;
    } else if (x >= 170_000 && x <= 200_000) {
        return 0;
    }

    return null;
}


function high_mileage(x) {
    if (x >= 0 && x <= 150_000) {
        return 0;
    } else if (x > 150_000 && x < 190_000) {
        return (x - 150_000) / 40_000;
    } else if (x >= 190_000 && x <= 200_000) {
        return 1;
    }

    return null;
}


const xMileageLow = [], yMileageLow = [];
const xMileageMedium = [], yMileageMedium = [];
const xMileageHigh = [], yMileageHigh = [];

for (let x = xMileageMin; x <= xMileageMax; x += mileageStep) { 
    xMileageLow.push(x.toFixed(1)); 
    yMileageLow.push(low_mileage(x)); 
}

for (let x = xMileageMin; x <= xMileageMax; x += mileageStep) { 
    xMileageMedium.push(x.toFixed(1)); 
    yMileageMedium.push(medium_mileage(x)); 
}

for (let x = xMileageMin; x <= xMileageMax; x += mileageStep) { 
    xMileageHigh.push(x.toFixed(1)); 
    yMileageHigh.push(high_mileage(x)); 
}

function createChart(xValues, yValues, chartName, chartTitle) {
    const ctx = document.getElementById(chartName).getContext('2d');

    new Chart(ctx, {
        type: 'line', // Line chart
        data: {
            labels: xValues, // x values
            datasets: [{
                label: chartTitle,
                data: yValues, // y values from the function
                borderColor: '#db8f23',
                fill: false, // No filling under the curve
                tension: 0.1
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'mileage'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'probability'
                    },
                    min: 0,
                    max: 1.2
                }
            }
        }
    });
}

window.addEventListener("load", createChart(xMileageLow, yMileageLow, "mileageLowDegree", "LOW"));
window.addEventListener("load", createChart(xMileageMedium, yMileageMedium, "mileageMediumDegree", "MEDIUM"));
window.addEventListener("load", createChart(xMileageHigh, yMileageHigh, "mileageHighDegree", "HIGH"));