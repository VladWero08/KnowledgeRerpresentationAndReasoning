const xPriceMin = 0;
const xPriceMax = 15;

function lowPrice(x) {
    if (x >= 0 && x <= 2) {
        return 1; 
    } else if (x > 2 && x <= 5) {
        return 1 - (x - 2) / 3;
    } else if (x > 5 && x <= 15) {
        return 0; 
    }

    return null; 
}

function mediumPrice(x) {
    if (x >= 0 && x <= 3) {
        return 0;
    } else if (x > 3 && x < 6) {
        return (x - 3) / 3; 
    } else if (x >= 6 && x <= 9) {
        return 1;
    } else if (x > 9 && x < 12) {
        return 1 - (x - 9) / 3; 
    } else if (x >= 12 && x <= 15) {
        return 0;
    }

    return null;
}


function highPrice(x) {
    if (x >= 0 && x <= 8) {
        return 0;
    } else if (x > 8 && x < 13) {
        return (x - 8) / 5;
    } else if (x >= 13 && x <= 15) {
        return 1;
    }

    return null;
}

const xPriceLow = [], yPriceLow = [];
const xPriceMedium = [], yPriceMedium = [];
const xPriceHigh = [], yPriceHigh = [];

for (let x = xPriceMin; x <= xPriceMax; x += 0.01) { 
    xPriceLow.push(x.toFixed(1)); 
    yPriceLow.push(lowPrice(x)); 
}

for (let x = xPriceMin; x <= xPriceMax; x += 0.01) { 
    xPriceMedium.push(x.toFixed(1)); 
    yPriceMedium.push(mediumPrice(x)); 
}

for (let x = xPriceMin; x <= xPriceMax; x += 0.01) { 
    xPriceHigh.push(x.toFixed(1)); 
    yPriceHigh.push(highPrice(x)); 
}

function createChart(xValues, yValues, chartName, chartTitle) {
    const ctx = document.getElementById(chartName).getContext('2d');

    new Chart(ctx, {
        type: 'line', // Line chart
        data: {
            labels: xValues, // x values
            datasets: [{
                label: chartTitle,
                data: yValues, 
                borderColor: '#42f590',
                fill: false, 
                tension: 0.1
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'price'
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

window.addEventListener("load", createChart(xPriceLow, yPriceLow, "lowPriceDegree", "LOW"));
window.addEventListener("load", createChart(xPriceMedium, yPriceMedium, "mediumPriceDegree", "MEDIUM"));
window.addEventListener("load", createChart(xPriceHigh, yPriceHigh, "highPriceDegree", "HIGH"));