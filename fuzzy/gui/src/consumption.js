const xConsumMin = 0;
const xConsumMax = 15;

function lowConsum(x) {
    if (x >= 0 && x <= 1) {
        return 1; 
    } else if (x > 1 && x <= 6) {
        return -1 / 5 * (x - 1) + 1;
    } else if (x > 6 && x <= 15) {
        return 0; 
    }

    return null; 
}

function mediumConsum(x) {
    if (x >= 0 && x <= 4) {
        return 0
    } else if (x > 4 && x < 5) {
        return 1 * (x - 4);
    } else if (x >= 5 && x <= 8) {
        return 1;
    } else if (x > 8 && x < 11) {
        return -1 / 3 * (x - 8) + 1;
    } else if (x >= 11 && x <= 15) {
        return 0; 
    }

    return null;
}

function highConsum(x) {
    if (x >= 0 && x <= 7) {
        return 0;
    } else if (x > 7 && x < 12) {
        return 1 / 5 * (x - 7);
    } else if (x >= 12 && x <= 15) {
        return 1;
    }

    return null
}

const xConsumLow = [], yConsumLow = [];
const xConsumMedium = [], yConsumMedium = [];
const xConsumHigh = [], yConsumHigh = [];

for (let x = xConsumMin; x <= xConsumMax; x += 0.01) { 
    xConsumLow.push(x.toFixed(1)); 
    yConsumLow.push(lowConsum(x)); 
}

for (let x = xConsumMin; x <= xConsumMax; x += 0.01) { 
    xConsumMedium.push(x.toFixed(1)); 
    yConsumMedium.push(mediumConsum(x)); 
}

for (let x = xConsumMin; x <= xConsumMax; x += 0.01) { 
    xConsumHigh.push(x.toFixed(1)); 
    yConsumHigh.push(highConsum(x)); 
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
                borderColor: '#dbb923',
                fill: false, // No filling under the curve
                tension: 0.1
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'consumption'
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

window.addEventListener("load", createChart(xConsumLow, yConsumLow, "consumptionLowDegree", "LOW"));
window.addEventListener("load", createChart(xConsumMedium, yConsumMedium, "consumptionMediumDegree", "MEDIUM"));
window.addEventListener("load", createChart(xConsumHigh, yConsumHigh, "consumptionHighDegree", "HIGH"));