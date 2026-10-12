import express from "express";
import path from "path";
import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";
import { createServer as createViteServer } from "vite";

dotenv.config();

const app = express();
const PORT = 3000;

app.use(express.json());

// Initialize Gemini safely
let ai: GoogleGenAI | null = null;
try {
  const apiKey = process.env.GEMINI_API_KEY;
  if (apiKey && apiKey !== "MY_GEMINI_API_KEY") {
    ai = new GoogleGenAI({
      apiKey: apiKey,
      httpOptions: {
        headers: {
          'User-Agent': 'aistudio-build',
        },
      },
    });
  }
} catch (e) {
  console.error("Failed to initialize GoogleGenAI:", e);
}

// REST API for intelligent guidance
app.post("/api/gemini/assist", async (req, res) => {
  try {
    if (!ai) {
      return res.status(200).json({
        success: false,
        message: "Gemini API belum dikonfigurasi. Silakan tambahkan 'GEMINI_API_KEY' di Secrets panel.",
        suggestion: "Tips Belajar Cepat: Buat jadwal teratur, lakukan teknik Pomodoro (25 menit belajar, 5 menit istirahat), dan ulas kembali catatan dalam 24 jam!"
      });
    }

    const { type, contextData } = req.body;

    let systemInstruction = "Kamu adalah Asisten Akademik Pintar (Jadwal Kuliah Pintar) untuk mahasiswa Indonesia. Berikan saran yang ramah, taktis, menyemangati, dan sangat berguna.";
    let prompt = "";

    if (type === "schedule_optimization") {
      prompt = `Berikut adalah jadwal kuliah saya: ${JSON.stringify(contextData)}. Tolong berikan analisis singkat jadwal ini, sela waktu kosong yang dapat dipakai untuk belajar mandiri, dan tips manajemen waktu terbaik untuk melaluinya dengan sukses. Berikan maksimal 3 poin rekomendasi singkat.`;
    } else if (type === "task_advisor") {
      prompt = `Saya memiliki daftar tugas kuliah berikut: ${JSON.stringify(contextData)}. Tolong berikan strategi pengerjaan (prioritaskan yang mana berdasarkan tenggat waktu & prioritas), dan saran belajar cepat untuk menuntaskannya tanpa kelelahan. Maksimal 3 paragraf singkat.`;
    } else if (type === "note_summarizer") {
      prompt = `Tolong rangkum secara ringkas materi kuliah ini untuk dipelajari nanti: ${JSON.stringify(contextData)}. Sebutkan topik utama, 3 fakta kunci penting yang wajib diingat untuk ujian, dan 1 pertanyaan latihan mandiri yang relevan.`;
    } else {
      prompt = `Berikan tips produktivitas mahasiswa yang unik, cerdas, dan membakar semangat mahasiswa untuk memulai hari studi mereka dengan baik.`;
    }

    const response = await ai.models.generateContent({
      model: "gemini-3.5-flash",
      contents: prompt,
      config: {
        systemInstruction,
        temperature: 0.7,
      },
    });

    res.json({
      success: true,
      suggestion: response.text || "Tidak ada respons dari AI."
    });
  } catch (error: any) {
    console.error("Gemini assist error:", error);
    res.status(500).json({
      success: false,
      message: "Terjadi kesalahan internal saat memanggil asisten AI.",
      error: error.message
    });
  }
});

// Configure Vite integration
async function setupVite() {
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req: any, res: any) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }
}

setupVite().then(() => {
  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on port ${PORT}`);
  });
});
