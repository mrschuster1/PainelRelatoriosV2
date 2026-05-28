export const normalizeString = (str: string) => {
  if (!str) return '';
  return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
};

export const createAccentRegexPattern = (term: string) => {
  return term
    .replace(/[aáàãâä]/gi, '[aáàãâäAÁÀÃÂÄ]')
    .replace(/[eéèêë]/gi, '[eéèêëEÉÈÊË]')
    .replace(/[iíìîï]/gi, '[iíìîïIÍÌÎÏ]')
    .replace(/[oóòõôö]/gi, '[oóòõôöOÓÒÕÔÖ]')
    .replace(/[uúùûü]/gi, '[uúùûüUÚÙÛÜ]')
    .replace(/[cç]/gi, '[cçCÇ]');
};

export function levenshtein(a: string, b: string): number {
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;
  
  let prevRow = new Int32Array(b.length + 1);
  for (let j = 0; j <= b.length; j++) prevRow[j] = j;
  let curRow = new Int32Array(b.length + 1);

  for (let i = 1; i <= a.length; i++) {
    curRow[0] = i;
    for (let j = 1; j <= b.length; j++) {
      let cost = a[i - 1] === b[j - 1] ? 0 : 1;
      curRow[j] = Math.min(
        curRow[j - 1] + 1,
        prevRow[j] + 1,
        prevRow[j - 1] + cost
      );
    }
    let temp = prevRow;
    prevRow = curRow;
    prevRow = curRow; // Correcting a small potential bug in the original logic if it were to continue
    // Wait, the original logic had:
    // let temp = prevRow;
    // prevRow = curRow;
    // curRow = temp;
    // which is correct for swapping.
    curRow = temp;
  }
  return prevRow[b.length];
}

/**
 * Calculates a match score between 0 and 1.
 * 1 = exact match, 0 = no match.
 */
export function calculateFuzzyScore(searchWord: string, targetString: string): number {
    const normalizedSearch = normalizeString(searchWord);
    const normalizedTarget = normalizeString(targetString);
    
    if (normalizedTarget.includes(normalizedSearch)) {
        // Boost score based on how much of the string is covered
        return 0.8 + (normalizedSearch.length / normalizedTarget.length) * 0.2;
    }
    
    // For short words, only exact substring match counts
    if (normalizedSearch.length <= 3) return 0;
    
    const targetWords = normalizedTarget.split(/\s+/);
    let bestScore = 0;
    const tolerance = normalizedSearch.length >= 6 ? 2 : 1;
    
    for (const tw of targetWords) {
        const dist = levenshtein(normalizedSearch, tw);
        if (dist <= tolerance) {
            const score = 1 - (dist / Math.max(normalizedSearch.length, tw.length));
            if (score > bestScore) bestScore = score;
        }
    }
    
    return bestScore * 0.7; // Cap fuzzy matches lower than substring matches
}

export function fuzzyMatchWord(searchWord: string, targetString: string): boolean {
    return calculateFuzzyScore(searchWord, targetString) > 0.4;
}
