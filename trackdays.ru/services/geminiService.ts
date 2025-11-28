import { GoogleGenAI } from "@google/genai";

const apiKey = process.env.API_KEY || '';
const ai = new GoogleGenAI({ apiKey });

export const getRacingAdvice = async (userQuestion: string): Promise<string> => {
  if (!apiKey) {
    return "API Key not configured. Please check environment.";
  }

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: userQuestion,
      config: {
        systemInstruction: `You are an expert professional motorsport racing coach and engineer. 
        You specialize in track days, car setup, racing lines, and driving techniques (braking, apex, exit). 
        You are helpful, encouraging, and technically accurate. 
        Answer in Russian language. Keep answers concise (under 200 words) but informative.
        If the question is about safety, prioritize safety first.`,
      }
    });

    return response.text || "Извините, не удалось получить совет тренера прямо сейчас.";
  } catch (error) {
    console.error("Gemini Error:", error);
    return "Ошибка связи с пит-лейном (AI service error).";
  }
};