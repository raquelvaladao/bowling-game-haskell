

function main() {
    let userInput = recursiveUserArrayInput([]);
    let points = frame(userInput, 0, 0);
    console.log(points);
}

main();

function recursiveUserArrayInput(baseArray: number[]): number[] {
    let input: any = prompt();

    if(input == "")
        return baseArray;

    const arrayWithInput: any = input.split(" ").map(Number);
    return recursiveUserArrayInput(arrayWithInput);
}


function getAFrame(arr: number[]): number[] {
    if(arr[0] !== 10) {
        const pair: number[] = arr.slice(0, 2);
        return pair;
    }
    const first: number[] = arr.slice(0, 1);
    return first;
}

function computeNextRoundArrayTail(arr: number[], quantityOfTimesToPop: number): number[] {
    if(quantityOfTimesToPop == 0 || arr.length == 0)
        return arr;
    const popedOne: number[] = arr.slice(1);
    return computeNextRoundArrayTail(popedOne, quantityOfTimesToPop - 1);
}

function computeBonus(arr: number[], quantityOfTimesToBonus: number, bonus: number): number {
    if(quantityOfTimesToBonus == 0 || arr.length == 0){
        return bonus;
    }

    const bonusCount: number = bonus + arr[0];
    const popedArr: number[] = arr.slice(1);
    return computeBonus(popedArr, quantityOfTimesToBonus - 1, bonusCount);
}

function frame(arr: number[], points: number, marcadorDeFrames: number): number {
    if(marcadorDeFrames == 10)
        return points;

    const framePairOrSingle: number[] = getAFrame(arr);

    const nextRoundArray: number[] | undefined = computeNextRoundArrayTail(arr, framePairOrSingle.length);
    
    if(framePairOrSingle[0] === 10) {
        const pointsStrike: number = 10;
        const bonusStrike: number = computeBonus(nextRoundArray, 2, 0);
        printFrame(framePairOrSingle, nextRoundArray, 2, marcadorDeFrames);
        return frame(nextRoundArray, points + pointsStrike + bonusStrike, marcadorDeFrames + 1);
    }

    if(framePairOrSingle.length == 2 && framePairOrSingle[0] + framePairOrSingle[1] === 10) {
        const pointsSpare: number = 10;
        const bonusSpare: number = computeBonus(nextRoundArray, 1, 0);
        printFrame(framePairOrSingle, nextRoundArray, 1, marcadorDeFrames);
        return frame(nextRoundArray, points + pointsSpare + bonusSpare, marcadorDeFrames + 1);
    }
    const pointsPair: number = framePairOrSingle.reduce((a, b) => a + b, 0);
    printFrame(framePairOrSingle, nextRoundArray, 3, marcadorDeFrames);
    return frame(nextRoundArray, points + pointsPair, marcadorDeFrames + 1);
}


//didnt finish this function in typescript. although its fully working in haskell.
function printFrame(frame: number[], nextArray: number[], isSpareOrStrikeOrPair: number, marcadorDeFrames: number) {

    if(isSpareOrStrikeOrPair == 1){
        //spare
        if(nextArray.length == 1) {
            console.log(frame[0], " / ", nextArray[0]," | ");
        } else {
            if(marcadorDeFrames < 10)
                console.log(frame[0], " / | ");
            else
                console.log(frame[0], " /");
        }
    }
    if(isSpareOrStrikeOrPair == 2){
        //strike
        if(marcadorDeFrames < 7)
            console.log("X_| ");
        else
            console.log("X ");
    }
    if(isSpareOrStrikeOrPair == 3){
        //strike
        if(marcadorDeFrames <= 8)
            console.log( frame[0], frame[1], " | ");
        else
            console.log(frame[0], frame[1]);
    }
}