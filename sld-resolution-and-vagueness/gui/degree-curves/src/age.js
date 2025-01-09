// chart.js
const xAgeMin = 0;
const xAgeMax = 15;
const baseFunctionName = "age";

function newAged(x) {
    if (x >= 0 && x <= 2) {
        return 1; 
    } else if (x > 2 && x <= 5) {
        return 1 - (x - 2) / 3;
    } else if (x > 5 && x <= 15) {
        return 0; 
    }

    return null; 
}

function middleAged(x) {
    if (x >= 0 && x <= 3) {
        return 0
    } else if (x > 3 && x < 5) {
        return (1 / 2) * x - 3 / 2;
    } else if (x >= 5 && x <= 8) {
        return 1;
    } else if (x > 8 && x < 10) {
        return (-1 / 2) * x + 5;
    } else if (x >= 10 && x <= 15) {
        return 0; 
    }

    return null;
}

function oldAged(x) {
    if (x >= 0 && x <= 7) {
        return 0;
    } else if (x > 7 && x < 10) {
        return (1 / 3) * x - 7 / 3;
    } else if (x >= 10 && x <= 15) {
        return 1;
    }

    return null
}

const xOld = [], yOld = [];
const xMiddle = [], yMiddle = [];
const xNew = [], yNew = [];

for (let x = xAgeMin; x <= xAgeMax; x += 0.01) { 
    xOld.push(x.toFixed(1)); 
    yOld.push(oldAged(x)); 
}

for (let x = xAgeMin; x <= xAgeMax; x += 0.01) { 
    xMiddle.push(x.toFixed(1)); 
    yMiddle.push(middleAged(x)); 
}

for (let x = xAgeMin; x <= xAgeMax; x += 0.01) { 
    xNew.push(x.toFixed(1)); 
    yNew.push(newAged(x)); 
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
                borderColor: '#a83232',
                fill: false, // No filling under the curve
                tension: 0.1
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: baseFunctionName
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

window.addEventListener("load", createChart(xOld, yOld, "ageOldDegree", "OLD"));
window.addEventListener("load", createChart(xMiddle, yMiddle, "ageMiddleDegree", "MIDDLE"));
window.addEventListener("load", createChart(xNew, yNew, "ageNewDegree", "NEW"));