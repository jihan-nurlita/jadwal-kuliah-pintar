import React, { useState, useEffect } from 'react';
import { 
  Clock, 
  Calendar as CalendarIcon, 
  CheckSquare, 
  Plus, 
  Trash2, 
  Edit, 
  BookOpen, 
  User, 
  Settings as SettingsIcon, 
  Sun, 
  Moon, 
  ChevronRight, 
  Play, 
  Check, 
  Search, 
  FileText, 
  Sparkles, 
  Bell, 
  LogOut, 
  Info, 
  Globe, 
  FileDown, 
  Folder, 
  FolderOpen, 
  Terminal, 
  CheckCircle,
  Copy,
  AlertCircle,
  Menu,
  ChevronLeft,
  X,
  FileCode,
  GraduationCap
} from 'lucide-react';
import { flutterCodebase } from './flutterCodebase';
import { Schedule, Task, Note, AppReminder } from './types';

// Dummy Data Init
const initialSchedules: Schedule[] = [
  {
    id: "s1",
    namaMatkul: "Pemrograman Mobile",
    dosen: "Budi Santoso, S.Kom., M.T.",
    ruangan: "Ruang B303",
    hari: "Senin",
    mulai: "08:00",
    selesai: "09:40"
  },
  {
    id: "s2",
    namaMatkul: "Sistem Informasi",
    dosen: "Siti Rahma, M.Kom.",
    ruangan: "Ruang A102",
    hari: "Selasa",
    mulai: "10:00",
    selesai: "11:40"
  },
  {
    id: "s3",
    namaMatkul: "Basis Data",
    dosen: "Aditya Pratama, M.Sc.",
    ruangan: "Ruang C305",
    hari: "Rabu",
    mulai: "13:00",
    selesai: "14:40"
  },
  {
    id: "s4",
    namaMatkul: "Desain UI/UX",
    dosen: "Soleh Solihun, M.Ds.",
    ruangan: "Lab Komputer 2",
    hari: "Kamis",
    mulai: "15:00",
    selesai: "16:40"
  }
];

const initialTasks: Task[] = [
  {
    id: "t1",
    namaTugas: "Desain UI/UX",
    namaMatkul: "Kumpul Tugas UI/UX Pratama",
    deadline: "2026-06-25",
    prioritas: "Tinggi",
    deskripsi: "Buat wireframe dan kumpulkan prototype figma.",
    selesai: false
  },
  {
    id: "t2",
    namaTugas: "Tugas SQL Query",
    namaMatkul: "Basis Data",
    deadline: "2026-06-28",
    prioritas: "Sedang",
    deskripsi: "Selesaikan 10 query DML di modul praktikum.",
    selesai: true
  },
  {
    id: "t3",
    namaTugas: "Project Akhir",
    namaMatkul: "Pemrograman Mobile",
    deadline: "2026-07-05",
    prioritas: "Tinggi",
    deskripsi: "Bikin aplikasi CRUD Flutter berbasis SharedPreferences.",
    selesai: false
  }
];

const initialNotes: Note[] = [
  {
    id: "n1",
    judul: "Pengenalan Flutter & Dart",
    isiCatatan: "Flutter adalah SDK buatan Google untuk membangun aplikasi multi-platform. Dart menggunakan konsep Object-Oriented Programming (OOP) yang serupa dengan Java/C++.",
    tanggal: "2026-06-21",
    kategori: "Pemrograman"
  },
  {
    id: "n2",
    judul: "Normalisasi database",
    isiCatatan: "Normalisasi adalah teknik perancangan database untuk meminimalkan redundansi tabel database melalui 1NF, 2NF, dan 3NF.",
    tanggal: "2026-06-20",
    kategori: "Basis Data"
  }
];

const initialReminders: AppReminder[] = [
  { id: "r1", title: "Jadwal Kuliah", time: "07:30", isActive: true, type: "Jadwal Kuliah" },
  { id: "r2", title: "Tugas Deadline", time: "19:00", isActive: true, type: "Deadline Tugas" },
  { id: "r3", title: "Sesi Belajar", time: "20:00", isActive: false, type: "Belajar" }
];

export default function App() {
  // Navigation & Simulated states
  const [appState, setAppState] = useState<'splash' | 'onboarding' | 'login' | 'app'>('splash');
  const [onboardingIndex, setOnboardingIndex] = useState(0);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [menuIndex, setMenuIndex] = useState(0); // 0: Home, 1: Schedule, 2: Tasks, 3: Calendar, 4: Notes & AI, 5: Profile & Settings

  // App Core state (React LocalStorage persisted)
  const [schedules, setSchedules] = useState<Schedule[]>(() => {
    const local = localStorage.getItem('pk_schedules');
    return local ? JSON.parse(local) : initialSchedules;
  });
  const [tasks, setTasks] = useState<Task[]>(() => {
    const local = localStorage.getItem('pk_tasks');
    return local ? JSON.parse(local) : initialTasks;
  });
  const [notes, setNotes] = useState<Note[]>(() => {
    const local = localStorage.getItem('pk_notes');
    return local ? JSON.parse(local) : initialNotes;
  });
  const [reminders, setReminders] = useState<AppReminder[]>(() => {
    const local = localStorage.getItem('pk_reminders');
    return local ? JSON.parse(local) : initialReminders;
  });

  // Dark mode & configuration
  const [isDarkMode, setIsDarkMode] = useState<boolean>(() => {
    return localStorage.getItem('theme_mode') === 'dark';
  });
  const [language, setLanguage] = useState<'id' | 'en'>('id');
  const [isNotifActive, setIsNotifActive] = useState(true);

  // Search State
  const [subSearch, setSubSearch] = useState('');

  // Selected entities for Detail or edit modals
  const [selectedTask, setSelectedTask] = useState<Task | null>(null);
  const [isTaskModalOpen, setIsTaskModalOpen] = useState(false);
  const [isAddScheduleModalOpen, setIsAddScheduleModalOpen] = useState(false);
  const [isAddTaskModalOpen, setIsAddTaskModalOpen] = useState(false);
  const [isAddNoteModalOpen, setIsAddNoteModalOpen] = useState(false);

  // New models temporary data
  const [newSchedule, setNewSchedule] = useState({
    namaMatkul: '', dosen: '', ruangan: '', hari: 'Senin', mulai: '08:00', selesai: '09:40'
  });
  const [newTask, setNewTask] = useState({
    namaTugas: '', namaMatkul: '', deadline: '2026-06-24', prioritas: 'Sedang' as 'Rendah' | 'Sedang' | 'Tinggi', deskripsi: ''
  });
  const [newNote, setNewNote] = useState({
    judul: '', isiCatatan: '', kategori: 'Pemrograman' as 'Pemrograman' | 'Basis Data' | 'UI/UX' | 'Lainnya'
  });

  // AI & Chat assistant state
  const [aiResponse, setAiResponse] = useState<string>('');
  const [loadingAi, setLoadingAi] = useState(false);
  const [selectedNoteForAi, setSelectedNoteForAi] = useState<string | null>(null);

  // Flutter workspace drawer toggle & state
  const [isFlutterDrawerOpen, setIsFlutterDrawerOpen] = useState(true);
  const [selectedFlutterFile, setSelectedFlutterFile] = useState<string>('lib/main.dart');
  const [copiedNotification, setCopiedNotification] = useState(false);

  // Sync state to LocalStorage
  useEffect(() => {
    localStorage.setItem('pk_schedules', JSON.stringify(schedules));
  }, [schedules]);
  useEffect(() => {
    localStorage.setItem('pk_tasks', JSON.stringify(tasks));
  }, [tasks]);
  useEffect(() => {
    localStorage.setItem('pk_notes', JSON.stringify(notes));
  }, [notes]);
  useEffect(() => {
    localStorage.setItem('pk_reminders', JSON.stringify(reminders));
  }, [reminders]);
  useEffect(() => {
    localStorage.setItem('theme_mode', isDarkMode ? 'dark' : 'light');
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDarkMode]);

  // Handle Splash duration
  useEffect(() => {
    if (appState === 'splash') {
      const timer = setTimeout(() => {
        const loggedIn = localStorage.getItem('pk_logged_in') === 'true';
        if (loggedIn) {
          const savedEmail = localStorage.getItem('pk_email') || '';
          setEmail(savedEmail);
          setAppState('app');
        } else {
          setAppState('onboarding');
        }
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [appState]);

  // Copy code helper
  const handleCopyCode = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedNotification(true);
    setTimeout(() => setCopiedNotification(false), 2500);
  };

  // Login Handler
  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !password.trim()) return;
    localStorage.setItem('pk_logged_in', 'true');
    localStorage.setItem('pk_email', email);
    setAppState('app');
  };

  // Logout Handler
  const handleLogout = () => {
    localStorage.removeItem('pk_logged_in');
    setAppState('login');
  };

  // Add / Edit operations
  const handleCreateSchedule = (e: React.FormEvent) => {
    e.preventDefault();
    const newId = 'sch_' + Date.now();
    setSchedules([...schedules, { id: newId, ...newSchedule }]);
    setIsAddScheduleModalOpen(false);
    setNewSchedule({ namaMatkul: '', dosen: '', ruangan: '', hari: 'Senin', mulai: '08:00', selesai: '09:40' });
  };

  const handleCreateTask = (e: React.FormEvent) => {
    e.preventDefault();
    const newId = 'tsk_' + Date.now();
    setTasks([...tasks, { id: newId, ...newTask, selesai: false }]);
    setIsAddTaskModalOpen(false);
    setNewTask({ namaTugas: '', namaMatkul: '', deadline: '2026-06-24', prioritas: 'Sedang', deskripsi: '' });
  };

  const handleCreateNote = (e: React.FormEvent) => {
    e.preventDefault();
    const newId = 'not_' + Date.now();
    const today = new Date().toISOString().split('T')[0];
    setNotes([...notes, { id: newId, ...newNote, tanggal: today }]);
    setIsAddNoteModalOpen(false);
    setNewNote({ judul: '', isiCatatan: '', kategori: 'Pemrograman' });
  };

  const handleDeleteSchedule = (id: string) => {
    if (window.confirm('Hapus jadwal kuliah ini?')) {
      setSchedules(schedules.filter(s => s.id !== id));
    }
  };

  const handleDeleteTask = (id: string) => {
    setTasks(tasks.filter(t => t.id !== id));
    setIsTaskModalOpen(false);
  };

  const handleDeleteNote = (id: string) => {
    if (window.confirm('Hapus catatan ini?')) {
      setNotes(notes.filter(n => n.id !== id));
    }
  };

  const handleToggleTask = (id: string) => {
    setTasks(tasks.map(t => t.id === id ? { ...t, selesai: !t.selesai } : t));
  };

  // AI assistant integration
  const askGemini = async (type: string, contextData: any) => {
    setLoadingAi(true);
    setAiResponse('');
    try {
      const response = await fetch('/api/gemini/assist', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type, contextData }),
      });
      const data = await response.json();
      setAiResponse(data.suggestion);
    } catch (err) {
      setAiResponse('Gagal terhubung dengan asisten akademik. Coba cek koneksi Anda.');
      console.error(err);
    } finally {
      setLoadingAi(false);
    }
  };

  // Stats calculate
  const totalMatkul = schedules.length;
  const totalTugas = tasks.length;
  const completedTaskCount = tasks.filter(t => t.selesai).length;
  const activeTaskCount = tasks.filter(t => !t.selesai).length;
  const notesCount = notes.length;

  const percentageTasks = totalTugas > 0 ? Math.round((completedTaskCount / totalTugas) * 100) : 0;

  // Onboarding Slides definitions
  const onboardingSlides = [
    {
      title: "Kelola Jadwal Kuliah",
      desc: "Simpan semua mata kuliah, dosen pengampu, dan ruangan kelasmu dalam satu genggaman modern.",
      themeColor: "from-blue-600 to-indigo-700",
      icon: <CalendarIcon className="w-24 h-24 text-white" />
    },
    {
      title: "Pantau Deadline Tugas",
      desc: "Hindari terlambat mengumpul tugas dengan notifikasi pengingat pintar dan pantauan prioritas matang.",
      themeColor: "from-pink-500 to-rose-600",
      icon: <CheckSquare className="w-24 h-24 text-white" />
    },
    {
      title: "Asisten Catatan Pintar",
      desc: "Gunakan AI Generatif untuk merangkum catatan kuliah dan memberikan tips belajar terbaik.",
      themeColor: "from-yellow-500 to-amber-600",
      icon: <Sparkles className="w-24 h-24 text-white" />
    }
  ];

  return (
    <div className={`min-h-screen font-sans ${isDarkMode ? 'bg-zinc-950 text-white' : 'bg-slate-50 text-slate-900'} transition-colors duration-300 flex overflow-hidden`}>

      {/* LEFT SIDE: REACT APP WORKSPACE VIEW (MOBILE EMULATOR) */}
      <div className={`flex-1 flex flex-col items-center justify-center p-4 lg:p-8 relative overflow-y-auto ${isFlutterDrawerOpen ? 'lg:mr-[42%]' : ''} transition-all duration-300`}>
        
        {/* TOP METADATA OR HELPER BAR */}
        <div className="w-full max-w-sm mb-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <GraduationCap className="text-indigo-600 dark:text-indigo-400 w-8 h-8" />
            <h1 className="font-extrabold text-lg text-slate-800 dark:text-zinc-100 tracking-tight">Jadwal Kuliah Pintar</h1>
          </div>
          
          <button 
            onClick={() => setIsFlutterDrawerOpen(!isFlutterDrawerOpen)} 
            className="flex items-center gap-1 bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-1.5 rounded-full text-xs font-semibold shadow-md transition-all duration-200 cursor-pointer"
          >
            <Terminal size={14} />
            <span>{isFlutterDrawerOpen ? 'Sembunyikan Flutter Code' : 'Lihat Source Flutter'}</span>
          </button>
        </div>

        {/* SMARTPHONE EMULATOR FRAME */}
        <div className="w-full max-w-[385px] h-[780px] bg-black rounded-[50px] p-3 shadow-2xl relative border-4 border-slate-800 dark:border-zinc-800 flex flex-col overflow-hidden">
          
          {/* CAMERA NOTCH */}
          <div className="absolute top-4 left-1/2 transform -translate-x-1/2 w-32 h-5 bg-black rounded-full z-50 flex items-center justify-center">
            <div className="w-3 h-3 bg-zinc-900 rounded-full border border-zinc-800"></div>
          </div>

          {/* APPLICATION VIEWPORT SCREEN */}
          <div className={`w-full h-full rounded-[40px] overflow-hidden relative flex flex-col ${isDarkMode ? 'bg-zinc-900' : 'bg-slate-50'}`}>
            
            {/* 1. SPLASH SCREEN */}
            {appState === 'splash' && (
              <div className="w-full h-full bg-gradient-to-tr from-indigo-700 to-indigo-900 flex flex-col items-center justify-center text-white p-6 relative">
                <div className="animate-bounce mb-6 bg-white/10 p-5 rounded-3xl border border-white/20 shadow-xl">
                  <GraduationCap className="w-20 h-20 text-white" />
                </div>
                <h1 className="text-2xl font-black tracking-tight text-center">Jadwal Kuliah Pintar</h1>
                <p className="text-indigo-200 text-sm mt-2 font-medium text-center italic">"Kelola Kuliahmu Lebih Mudah"</p>
                <div className="absolute bottom-16 flex items-center gap-1">
                  <span className="w-2.5 h-2.5 bg-white/70 rounded-full animate-ping"></span>
                  <span className="text-xs text-indigo-300 font-mono tracking-widest uppercase">Loading Sim...</span>
                </div>
              </div>
            )}

            {/* 2. ONBOARDING SCREEN */}
            {appState === 'onboarding' && (
              <div className="w-full h-full flex flex-col justify-between p-6">
                <div className="flex justify-end pt-4">
                  <button 
                    onClick={() => setAppState('login')} 
                    className="text-xs text-slate-400 font-semibold hover:text-indigo-600 transition"
                  >
                    Lewati
                  </button>
                </div>

                <div className="flex flex-col items-center text-center my-auto px-4">
                  <div className={`bg-gradient-to-br ${onboardingSlides[onboardingIndex].themeColor} p-6 rounded-[32px] shadow-lg mb-8`}>
                    {onboardingSlides[onboardingIndex].icon}
                  </div>
                  <h3 className="text-xl font-bold dark:text-white text-slate-800 mb-2">
                    {onboardingSlides[onboardingIndex].title}
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-zinc-400 leading-relaxed">
                    {onboardingSlides[onboardingIndex].desc}
                  </p>
                </div>

                <div className="flex flex-col items-center gap-6 pb-6 w-full">
                  {/* Indicators */}
                  <div className="flex gap-1.5 justify-center">
                    {onboardingSlides.map((_, i) => (
                      <span 
                        key={i} 
                        className={`h-2 rounded-full transition-all duration-300 ${onboardingIndex === i ? 'w-6 bg-indigo-600' : 'w-2 bg-slate-200 dark:bg-zinc-700'}`}
                      />
                    ))}
                  </div>

                  {/* Buttons */}
                  {onboardingIndex < 2 ? (
                    <button 
                      onClick={() => setOnboardingIndex(onboardingIndex + 1)}
                      className="w-full bg-indigo-600 text-white font-bold py-3 px-5 rounded-2xl flex items-center justify-center gap-2 hover:bg-indigo-700 transition"
                    >
                      <span>Lanjut</span>
                      <ChevronRight size={16} />
                    </button>
                  ) : (
                    <button 
                      onClick={() => setAppState('login')}
                      className="w-full bg-emerald-600 text-white font-bold py-3 px-5 rounded-2xl flex items-center justify-center gap-2 hover:bg-emerald-700 transition"
                    >
                      <Play size={16} />
                      <span>Mulai</span>
                    </button>
                  )}
                </div>
              </div>
            )}

            {/* 3. LOGIN SCREEN */}
            {appState === 'login' && (
              <div className="w-full h-full flex flex-col justify-between p-6 dark:bg-zinc-900 bg-white">
                <div className="text-center pt-10">
                  <h2 className="text-2xl font-black text-slate-800 dark:text-white">Selamat Datang!</h2>
                  <p className="text-xs text-slate-500 mt-2">Masuk untuk mengelola jadwal perkuliahan secara pintar</p>
                </div>

                <form onSubmit={handleLogin} className="flex flex-col gap-4 px-2">
                  <div>
                    <label className="text-xs font-bold text-slate-600 dark:text-zinc-300 uppercase tracking-widest block mb-1">Email Dummy</label>
                    <input 
                      type="email" 
                      placeholder="mahasiswa@kampus.ac.id" 
                      required
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="w-full px-4 py-2.5 rounded-xl border border-slate-200 dark:border-zinc-700 dark:bg-zinc-800 dark:text-white focus:outline-none focus:ring-1 focus:ring-indigo-500 text-sm"
                    />
                  </div>
                  <div>
                    <label className="text-xs font-bold text-slate-600 dark:text-zinc-300 uppercase tracking-widest block mb-1">Password Dummy</label>
                    <input 
                      type="password" 
                      placeholder="••••••" 
                      required
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className="w-full px-4 py-2.5 rounded-xl border border-slate-200 dark:border-zinc-700 dark:bg-zinc-800 dark:text-white focus:outline-none focus:ring-1 focus:ring-indigo-500 text-sm"
                    />
                  </div>
                  
                  <div className="text-left py-1">
                    <span className="text-[10px] text-indigo-600 dark:text-indigo-400 font-medium">* Simulasi SharedPreferences diaktifkan</span>
                  </div>

                  <button 
                    type="submit"
                    className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 rounded-xl shadow-md transition-all text-sm block"
                  >
                    Masuk
                  </button>
                </form>

                <div className="text-center pb-6">
                  <p className="text-[11px] text-slate-400">Jadwal Kuliah Pintar — Flutter Web Emulator v1.0</p>
                </div>
              </div>
            )}

            {/* 4. MAIN APP CONTAINER AND PAGES */}
            {appState === 'app' && (
              <>
                {/* Header App */}
                <div className="px-5 pt-10 pb-4 bg-indigo-600 text-white flex items-center justify-between shadow-sm">
                  <div>
                    <span className="text-[10px] uppercase font-bold text-indigo-200 tracking-wider">Dashboard Mahasiswa</span>
                    <h3 className="text-base font-bold truncate max-w-[200px]">Halo, {email.split('@')[0]} 👋</h3>
                  </div>
                  <div className="flex items-center gap-2">
                    <button 
                      onClick={() => {
                        setIsDarkMode(!isDarkMode);
                        setIsNotifActive(p => {
                          if (p) {
                            alert("Dark mode diaktifkan");
                          }
                          return p;
                        });
                      }}
                      className="p-1.5 hover:bg-white/15 rounded-full transition"
                    >
                      {isDarkMode ? <Sun size={18} /> : <Moon size={18} />}
                    </button>
                    <button 
                      onClick={() => setMenuIndex(5)} 
                      className="p-1.5 hover:bg-white/15 rounded-full transition relative"
                    >
                      <SettingsIcon size={18} />
                    </button>
                  </div>
                </div>

                {/* SCROLLABLE SCENERY BODY */}
                <div className="flex-1 overflow-y-auto p-4 space-y-4">
                  
                  {/* MENU 0: HOME / BERANDA */}
                  {menuIndex === 0 && (
                    <div className="space-y-4">
                      {/* STATS BENTO GROUP */}
                      <div className="grid grid-cols-2 gap-2">
                        <div className="bg-gradient-to-br from-indigo-500 to-indigo-700 text-white p-3.5 rounded-2xl shadow-sm">
                          <span className="text-[10px] block font-medium opacity-80">Total Matkul</span>
                          <span className="text-2xl font-black block mt-0.5">{totalMatkul}</span>
                        </div>
                        <div className="bg-gradient-to-br from-pink-500 to-rose-600 text-white p-3.5 rounded-2xl shadow-sm">
                          <span className="text-[10px] block font-medium opacity-80">Total Tugas</span>
                          <span className="text-2xl font-black block mt-0.5">{totalTugas}</span>
                        </div>
                      </div>

                      {/* STATISTIC PIE PROGRESS CHART */}
                      <div className="bg-white dark:bg-zinc-800 p-4 rounded-3xl shadow-sm border border-slate-100 dark:border-zinc-700/50 flex items-center justify-between">
                        <div>
                          <h4 className="text-xs uppercase font-bold tracking-wider text-slate-400">Progress Tugas</h4>
                          <span className="text-lg font-extrabold mt-1 block text-indigo-600 dark:text-indigo-400">
                            {percentageTasks}% Selesai
                          </span>
                          <p className="text-[10px] text-slate-400 mt-0.5">{completedTaskCount} Selesai dari {totalTugas} Tugas</p>
                        </div>
                        <div className="relative w-12 h-12 flex items-center justify-center">
                          <svg className="w-full h-full transform -rotate-90">
                            <circle cx="24" cy="24" r="20" stroke="#E2E8F0" strokeWidth="4" fill="transparent" className="opacity-30" />
                            <circle cx="24" cy="24" r="20" stroke="#3F51B5" strokeWidth="4" fill="transparent" 
                                    strokeDasharray={2 * Math.PI * 20} 
                                    strokeDashoffset={(2 * Math.PI * 20) * (1 - percentageTasks / 100)} />
                          </svg>
                          <span className="absolute text-[10px] font-bold">{percentageTasks}%</span>
                        </div>
                      </div>

                      {/* JADWAL HARI INI */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <h3 className="text-xs uppercase tracking-widest font-black text-slate-400">Jadwal Hari Ini</h3>
                          <button onClick={() => setMenuIndex(1)} className="text-[10px] text-indigo-600 dark:text-indigo-400 font-bold hover:underline">Lihat Semua</button>
                        </div>

                        {schedules.length === 0 ? (
                          <div className="p-4 bg-slate-100 dark:bg-zinc-800 rounded-2xl text-center text-xs text-slate-400">
                             Tidak ada jadwal kuliah hari ini.
                          </div>
                        ) : (
                          <div className="space-y-2">
                            {schedules.slice(0, 2).map((sch) => (
                              <div key={sch.id} className="bg-white dark:bg-zinc-800 p-3.5 rounded-2xl border border-slate-100 dark:border-zinc-700/50 flex justify-between items-center shadow-xs">
                                <div className="space-y-0.5">
                                  <span className="bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-300 px-2 py-0.5 rounded text-[9px] font-bold inline-block">
                                    {sch.hari}
                                  </span>
                                  <h4 className="font-bold text-xs max-w-[160px] truncate">{sch.namaMatkul}</h4>
                                  <p className="text-[10px] text-slate-400">{sch.dosen.split(',')[0]} • {sch.ruangan}</p>
                                </div>
                                <div className="text-right flex items-center gap-1 bg-indigo-50/50 dark:bg-zinc-900/50 px-2 py-1 rounded-xl">
                                  <Clock className="w-3.5 h-3.5 text-indigo-500" />
                                  <span className="text-[10px] font-bold tracking-tight text-indigo-600 dark:text-indigo-300">{sch.mulai}</span>
                                </div>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      {/* TUGAS DEADLINE TERDEKAT */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <h3 className="text-xs uppercase tracking-widest font-black text-slate-400">Deadline Terdekat</h3>
                          <button onClick={() => setMenuIndex(2)} className="text-[10px] text-indigo-600 dark:text-indigo-400 font-bold hover:underline">Semua Tugas</button>
                        </div>
                        {tasks.filter(t => !t.selesai).length === 0 ? (
                          <div className="p-4 bg-slate-100 dark:bg-zinc-800 rounded-2xl text-center text-xs text-slate-400">
                            Yay! Tidak ada deadline tugas tersisa. 🎉
                          </div>
                        ) : (
                          <div className="space-y-2">
                            {tasks.filter(t => !t.selesai).slice(0, 2).map(task => (
                              <div key={task.id} className="bg-white dark:bg-zinc-800 p-3.5 rounded-2xl border border-slate-100 dark:border-zinc-700/50 space-y-1.5 shadow-xs">
                                <div className="flex items-center justify-between">
                                  <span className="text-[9px] text-red-500 bg-red-50 dark:bg-red-950/40 px-2 py-0.5 rounded font-black uppercase tracking-wider">
                                    {task.prioritas}
                                  </span>
                                  <span className="text-[9px] text-slate-400 font-mono flex items-center gap-0.5">
                                    <Clock size={10} />
                                    {task.deadline}
                                  </span>
                                </div>
                                <h4 className="font-bold text-xs">{task.namaTugas}</h4>
                                <p className="text-[10px] text-slate-400 line-clamp-1">{task.deskripsi}</p>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      {/* QUICK NOTES COMPENDIUM */}
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <h3 className="text-xs uppercase tracking-widest font-black text-slate-400">Catatan Baru</h3>
                          <button onClick={() => setMenuIndex(4)} className="text-[10px] text-indigo-600 dark:text-indigo-400 font-bold hover:underline">Semua Catatan</button>
                        </div>
                        <div className="grid grid-cols-2 gap-2">
                          {notes.slice(0, 2).map(n => (
                            <div key={n.id} className="bg-indigo-50/30 dark:bg-zinc-800/60 p-3 rounded-2xl border border-dashed border-indigo-100 dark:border-zinc-700/60 space-y-1">
                              <span className="text-[8px] text-indigo-600 dark:text-indigo-400 font-bold">{n.kategori}</span>
                              <h5 className="font-bold text-[11px] truncate">{n.judul}</h5>
                              <p className="text-[10px] text-slate-400 line-clamp-2 leading-tight">{n.isiCatatan}</p>
                            </div>
                          ))}
                        </div>
                      </div>

                    </div>
                  )}

                  {/* MENU 1: SCHEDULE / JADWAL */}
                  {menuIndex === 1 && (
                    <div className="space-y-4">
                      <div className="flex justify-between items-center">
                        <h4 className="text-sm font-bold dark:text-white text-slate-800">Manajemen Kuliah</h4>
                        <button 
                          onClick={() => setIsAddScheduleModalOpen(true)}
                          className="bg-indigo-600 hover:bg-indigo-700 text-white p-1.5 rounded-xl flex items-center gap-1 text-[10px] font-bold"
                        >
                          <Plus size={14} />
                          <span>Kelas baru</span>
                        </button>
                      </div>

                      <div className="relative">
                        <Search className="absolute left-3 top-3 text-slate-400 w-4 h-4" />
                        <input 
                          type="text" 
                          placeholder="Cari matkul atau dosen..."
                          value={subSearch}
                          onChange={(e) => setSubSearch(e.target.value)}
                          className="w-full pl-9 pr-4 py-2 rounded-xl dark:bg-zinc-800 dark:border-zinc-700 bg-white border border-slate-200 text-xs text-slate-800 dark:text-zinc-100 placeholder-slate-400 focus:outline-none"
                        />
                      </div>

                      <div className="space-y-2">
                        {schedules
                        .filter(sch => 
                          sch.namaMatkul.toLowerCase().includes(subSearch.toLowerCase()) ||
                          sch.dosen.toLowerCase().includes(subSearch.toLowerCase())
                        )
                        .map(sch => (
                          <div key={sch.id} className="bg-white dark:bg-zinc-800 p-4 rounded-3xl border border-slate-100 dark:border-zinc-700/50 shadow-xs relative">
                            <button 
                              onClick={() => handleDeleteSchedule(sch.id)}
                              className="absolute top-4 right-4 text-rose-500 hover:text-rose-700 p-1 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-full transition"
                            >
                              <Trash2 size={14} />
                            </button>
                            
                            <span className="bg-indigo-600 text-white px-2.5 py-0.5 rounded-full text-[9px] font-bold leading-none inline-block mb-2">
                              {sch.hari}
                            </span>
                            
                            <h5 className="font-extrabold text-xs mb-1">{sch.namaMatkul}</h5>
                            <p className="text-[10px] text-slate-500 dark:text-zinc-400">Dosen: {sch.dosen}</p>
                            
                            <div className="mt-3 pt-3 border-t border-slate-100 dark:border-zinc-700/50 flex justify-between items-center">
                              <span className="text-[10px] font-semibold text-slate-400 uppercase tracking-widest">{sch.ruangan}</span>
                              <div className="flex items-center gap-1 text-indigo-600 dark:text-indigo-400">
                                <Clock size={12} />
                                <span className="text-[11px] font-mono font-bold">{sch.mulai} - {sch.selesai}</span>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>

                      {/* OPTIMIZER WIDGET */}
                      <div className="bg-gradient-to-tr from-indigo-700 to-indigo-900 text-white p-4 rounded-3xl shadow-sm space-y-2.5">
                        <div className="flex items-center gap-1.5">
                          <Sparkles className="text-yellow-400 w-5 h-5" />
                          <h5 className="font-black text-xs">Optimasi Jadwal Pintar</h5>
                        </div>
                        <p className="text-[10px] text-indigo-200">Ingin tahu waktu terbaik untuk belajar mandiri berdasarkan kelas kuliahmu?</p>
                        <button 
                          onClick={() => {
                            setMenuIndex(4);
                            askGemini("schedule_optimization", schedules);
                          }}
                          className="w-full bg-yellow-400 hover:bg-yellow-500 text-slate-900 text-[10px] font-black py-2 rounded-xl transition"
                        >
                          Minta Rekomendasi Asisten AI
                        </button>
                      </div>
                    </div>
                  )}

                  {/* MENU 2: TASKS / TUGAS */}
                  {menuIndex === 2 && (
                    <div className="space-y-4">
                      <div className="flex justify-between items-center">
                        <h4 className="text-sm font-bold dark:text-white text-slate-800">Tenggat Deadline</h4>
                        <button 
                          onClick={() => setIsAddTaskModalOpen(true)}
                          className="bg-emerald-600 hover:bg-emerald-700 text-white p-1.5 rounded-xl flex items-center gap-1 text-[10px] font-bold"
                        >
                          <Plus size={14} />
                          <span>Tugas baru</span>
                        </button>
                      </div>

                      <div className="flex bg-slate-100 dark:bg-zinc-800 p-1 rounded-xl">
                        <button 
                          onClick={() => setSubSearch('')}
                          className="flex-1 py-1 px-3 text-[10px] font-bold bg-white dark:bg-zinc-700 rounded-lg shadow-xs"
                        >
                          Semua ({tasks.length})
                        </button>
                        <button 
                          onClick={() => setSubSearch('selesai')}
                          className="flex-1 py-1 px-3 text-[10px] font-bold hover:text-indigo-600"
                        >
                          Selesai ({tasks.filter(t => t.selesai).length})
                        </button>
                        <button 
                          onClick={() => setSubSearch('belum')}
                          className="flex-1 py-1 px-3 text-[10px] font-bold hover:text-indigo-600"
                        >
                          Belum ({tasks.filter(t => !t.selesai).length})
                        </button>
                      </div>

                      <div className="space-y-2">
                        {tasks
                        .filter(t => {
                          if (subSearch === 'selesai') return t.selesai;
                          if (subSearch === 'belum') return !t.selesai;
                          return true;
                        })
                        .map(task => (
                          <div 
                            key={task.id} 
                            className={`p-3.5 rounded-3xl border transition shadow-xs flex items-start gap-3 relative ${task.selesai ? 'bg-slate-50 border-slate-100 opacity-60 dark:bg-zinc-800/40 dark:border-zinc-800' : 'bg-white border-slate-100 dark:bg-zinc-800 dark:border-zinc-700/50'}`}
                          >
                            <input 
                              type="checkbox" 
                              checked={task.selesai}
                              onChange={() => handleToggleTask(task.id)}
                              className="mt-1 w-4.5 h-4.5 text-indigo-600 bg-gray-100 border-gray-300 rounded-md focus:ring-indigo-500"
                            />

                            <div className="flex-1 space-y-1">
                              <div className="flex items-center gap-1.5 flex-wrap">
                                <span className={`text-[8px] font-bold px-1.5 py-0.5 rounded uppercase font-mono ${task.prioritas === 'Tinggi' ? 'bg-rose-100 text-rose-600 dark:bg-rose-950/45 dark:text-rose-400' : task.prioritas === 'Sedang' ? 'bg-amber-100 text-amber-600 dark:bg-amber-950/45 dark:text-amber-400' : 'bg-green-100 text-green-600'}`}>
                                  {task.prioritas}
                                </span>
                                <span className="text-[9px] text-slate-400 font-medium">Deadline: {task.deadline}</span>
                              </div>
                              <h5 className={`font-bold text-xs ${task.selesai ? 'line-through text-slate-400' : ''}`}>{task.namaTugas}</h5>
                              <p className="text-[10px] text-slate-400 max-w-[200px] truncate">{task.deskripsi}</p>
                            </div>

                            <button 
                              onClick={() => {
                                setSelectedTask(task);
                                setIsTaskModalOpen(true);
                              }}
                              className="text-slate-400 hover:text-slate-600 p-1"
                            >
                              <ChevronRight size={14} />
                            </button>
                          </div>
                        ))}
                      </div>

                      {/* STAT BIAS */}
                      <div className="p-4 bg-zinc-800 border border-zinc-700 text-white rounded-3xl">
                        <div className="flex items-center justify-between">
                          <span className="text-xs font-bold">Staf Penilai AI</span>
                          <Sparkles className="text-yellow-400 w-4 h-4" />
                        </div>
                        <p className="text-[10px] text-zinc-400 mt-1">Dapatkan estimasi tumpukan beban belajarmu dari asisten AI berdasarkan statistik tugas aktif saat ini.</p>
                        <button 
                          onClick={() => {
                            setMenuIndex(4);
                            askGemini("task_advisor", tasks.filter(t => !t.selesai));
                          }}
                          className="mt-2.5 w-full bg-zinc-700 hover:bg-zinc-600 text-white py-1.5 rounded-xl text-[10px] font-bold"
                        >
                          Analisis Tugas via Gemini
                        </button>
                      </div>

                    </div>
                  )}

                  {/* MENU 3: CALENDAR / KALENDER */}
                  {menuIndex === 3 && (
                    <div className="space-y-4">
                      <h4 className="text-sm font-bold dark:text-white text-slate-800">Kalender Akademik</h4>
                      
                      {/* SIMULATE TABLE CALENDAR */}
                      <div className="bg-white dark:bg-zinc-800 p-4 rounded-3xl border border-slate-100 dark:border-zinc-700/50 shadow-xs space-y-3">
                        <div className="flex justify-between items-center pb-2 border-b border-slate-100 dark:border-zinc-700/50">
                          <span className="text-xs font-black text-indigo-600 dark:text-indigo-400 uppercase tracking-widest">Juni 2026</span>
                          <div className="flex gap-2">
                            <span className="text-[9px] bg-indigo-50 dark:bg-zinc-900 px-2 py-0.5 rounded font-mono font-bold">UTC-7 SLAM</span>
                          </div>
                        </div>

                        {/* Calendar week header */}
                        <div className="grid grid-cols-7 text-center text-[10px] font-bold text-slate-400">
                          <span>Sen</span><span>Sel</span><span>Rab</span><span>Kam</span><span>Jum</span><span>Sab</span><span>Min</span>
                        </div>

                        <div className="grid grid-cols-7 text-center gap-1.5">
                          {/* Simulate grid starting from 1st June (Senin is day 1) */}
                          {Array.from({ length: 30 }).map((_, index) => {
                            const dateNum = index + 1;
                            const hasDeadlineString = dateNum === 25 || dateNum === 28;
                            const hasClassString = dateNum % 3 === 0;
                            return (
                              <div key={index} className={`py-1.5 rounded-xl text-xs relative flex flex-col items-center justify-center ${hasDeadlineString ? 'bg-red-50 dark:bg-rose-950/20 font-bold text-rose-500' : 'hover:bg-slate-100 dark:hover:bg-zinc-700/50'}`}>
                                <span>{dateNum}</span>
                                {hasDeadlineString && <span className="absolute bottom-1 w-1 h-1 bg-red-500 rounded-full"></span>}
                                {hasClassString && !hasDeadlineString && <span className="absolute bottom-1 w-1 h-1 bg-indigo-500 rounded-full"></span>}
                              </div>
                            );
                          })}
                        </div>
                      </div>

                      {/* LEAF AGENDA ON CALENDAR */}
                      <div>
                        <span className="text-[10px] uppercase font-bold tracking-widest text-slate-400 mb-2 block">Daftar Agenda Terdekat</span>
                        <div className="space-y-2">
                          <div className="bg-white dark:bg-zinc-800 p-3 rounded-2xl border border-slate-100 dark:border-zinc-700/50 flex justify-between items-center">
                            <div>
                              <span className="text-[8px] uppercase tracking-wider font-bold text-red-500">25 Juni 2026</span>
                              <h5 className="font-bold text-xs">Ujian / Deadline UI/UX</h5>
                            </div>
                            <span className="text-[10px] text-rose-500 bg-rose-50 dark:bg-red-950/30 font-bold px-2 py-0.5 rounded">Tinggi</span>
                          </div>

                          <div className="bg-white dark:bg-zinc-800 p-3 rounded-2xl border border-slate-100 dark:border-zinc-700/50 flex justify-between items-center">
                            <div>
                              <span className="text-[8px] uppercase tracking-wider font-bold text-indigo-500">28 Juni 2026</span>
                              <h5 className="font-bold text-xs">Modul SQL Basis Data</h5>
                            </div>
                            <span className="text-[10px] text-amber-500 bg-amber-50 dark:bg-amber-950/30 font-bold px-2 py-0.5 rounded">Sedang</span>
                          </div>
                        </div>
                      </div>

                    </div>
                  )}

                  {/* MENU 4: NOTES & INDONESIA SMART ASSISTANT */}
                  {menuIndex === 4 && (
                    <div className="space-y-4">
                      <div className="flex justify-between items-center">
                        <h4 className="text-sm font-bold dark:text-white text-slate-800">Catatan & Rangkuman AI</h4>
                        <button 
                          onClick={() => setIsAddNoteModalOpen(true)}
                          className="bg-indigo-600 hover:bg-indigo-700 text-white p-1.5 rounded-xl flex items-center gap-1 text-[10px] font-bold"
                        >
                          <Plus size={14} />
                          <span>Buat Catatan</span>
                        </button>
                      </div>

                      {/* NOTES LIST */}
                      <div className="space-y-2">
                        {notes.map(note => (
                          <div key={note.id} className="bg-white dark:bg-zinc-800 p-4 rounded-3xl border border-slate-100 dark:border-zinc-700/50 space-y-2 shadow-xs">
                            <div className="flex justify-between items-center">
                              <span className="bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 text-[9px] font-black px-2 py-0.5 rounded">
                                {note.kategori}
                              </span>
                              <button 
                                onClick={() => handleDeleteNote(note.id)}
                                className="text-rose-500 hover:text-rose-700 p-1"
                              >
                                <Trash2 size={13} />
                              </button>
                            </div>

                            <h5 className="font-extrabold text-xs">{note.judul}</h5>
                            <p className="text-[10px] text-slate-500 dark:text-zinc-400 leading-relaxed line-clamp-3">{note.isiCatatan}</p>
                            
                            <div className="pt-2 border-t border-slate-100 dark:border-zinc-700/50 flex justify-between items-center">
                              <span className="text-[9px] text-slate-400">{note.tanggal}</span>
                              <button 
                                onClick={() => {
                                  setSelectedNoteForAi(note.id);
                                  askGemini("note_summarizer", note);
                                }}
                                className="flex items-center gap-1 text-[9px] text-indigo-600 dark:text-indigo-400 font-extrabold hover:underline"
                              >
                                <Sparkles size={11} className="text-indigo-500 animate-spin" />
                                <span>Rangkum Materi via AI</span>
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>

                      {/* INTELLIGENT COMPANION RESPONSE PANEL */}
                      <div className="bg-violet-950 text-white p-4 rounded-3xl space-y-3 shadow-md border border-indigo-900/60">
                        <div className="flex items-center gap-2">
                          <div className="bg-white/10 p-1.5 rounded-xl">
                            <Sparkles className="text-yellow-400 w-4 h-4" />
                          </div>
                          <div>
                            <span className="text-[8px] uppercase tracking-wider font-extrabold block text-indigo-300">Asisten Pintar</span>
                            <h5 className="font-bold text-xs uppercase tracking-wide leading-none">Rekomendasi Belajar AI</h5>
                          </div>
                        </div>

                        {loadingAi ? (
                          <div className="space-y-2 py-2">
                            <div className="h-3.5 bg-white/10 rounded animate-pulse w-full"></div>
                            <div className="h-3.5 bg-white/10 rounded animate-pulse w-[85%]"></div>
                            <div className="h-3.5 bg-white/10 rounded animate-pulse w-[60%]"></div>
                          </div>
                        ) : aiResponse ? (
                          <div className="text-[11px] text-indigo-100 leading-relaxed font-sans max-h-48 overflow-y-auto pr-1 bg-white/5 p-2 rounded-2xl border border-white/5">
                            {aiResponse}
                          </div>
                        ) : (
                          <p className="text-[10px] text-indigo-200">Klik tombol "Rangkum Materi via AI" pada salah satu catatan kuliah di atas, atau minta tips umum sekarang juga!</p>
                        )}

                        <div className="flex gap-1">
                          <button 
                            disabled={loadingAi}
                            onClick={() => askGemini("general_tips", {})}
                            className="flex-1 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-[9px] font-bold"
                          >
                            Tips Studi Cepat
                          </button>
                          <button 
                            disabled={loadingAi}
                            onClick={() => {
                              setSelectedNoteForAi(null);
                              setAiResponse('');
                            }}
                            className="px-2.5 py-1.5 bg-white/10 hover:bg-white/20 text-white rounded-xl text-[9px]"
                          >
                            Reset
                          </button>
                        </div>
                      </div>

                    </div>
                  )}

                  {/* MENU 5: PROFILE & SETTINGS */}
                  {menuIndex === 5 && (
                    <div className="space-y-4">
                      {/* PROFILE DETAIL */}
                      <div className="bg-white dark:bg-zinc-800 p-4 rounded-3xl border border-slate-100 dark:border-zinc-700/50 shadow-xs text-center space-y-3">
                        <div className="relative w-16 h-16 mx-auto">
                          <div className="bg-indigo-600 rounded-full w-full h-full flex items-center justify-center text-white font-black text-xl">
                            {email ? email[0].toUpperCase() : 'M'}
                          </div>
                          <span className="absolute bottom-0 right-0 w-4 h-4 bg-emerald-500 border-2 border-white rounded-full"></span>
                        </div>
                        <div>
                          <h4 className="font-extrabold text-sm">{email ? email.split('@')[0] : 'Nama Mahasiswa'}</h4>
                          <span className="text-[10px] text-slate-400">NIM: 22104056 • Angkatan 2024</span>
                        </div>
                        <div className="grid grid-cols-2 gap-2 text-left bg-slate-50 dark:bg-zinc-900/50 p-2.5 rounded-2xl">
                          <div>
                            <span className="text-[8px] text-slate-400 uppercase block">Jurusan</span>
                            <span className="text-[10px] font-bold">Teknik Informatika</span>
                          </div>
                          <div>
                            <span className="text-[8px] text-slate-400 uppercase block">Semester</span>
                            <span className="text-[10px] font-bold">Semester 4 (Genap)</span>
                          </div>
                        </div>
                      </div>

                      {/* CONFIGURATION LIST */}
                      <div className="bg-white dark:bg-zinc-800 rounded-3xl border border-slate-100 dark:border-zinc-700/50 overflow-hidden divide-y divide-slate-100 dark:divide-zinc-700/50">
                        <div className="p-3.5 flex justify-between items-center">
                          <div className="flex items-center gap-2">
                            <Moon className="w-4 h-4 text-indigo-500" />
                            <span className="text-xs font-semibold">Mode Gelap</span>
                          </div>
                          <button 
                            onClick={() => setIsDarkMode(!isDarkMode)}
                            className={`w-10 h-5.5 rounded-full p-0.5 transition-colors duration-200 focus:outline-none ${isDarkMode ? 'bg-indigo-600 flex justify-end' : 'bg-slate-300 flex justify-start'}`}
                          >
                            <span className="w-4.5 h-4.5 bg-white rounded-full shadow-md"></span>
                          </button>
                        </div>

                        <div className="p-3.5 flex justify-between items-center">
                          <div className="flex items-center gap-2">
                            <Globe className="w-4 h-4 text-indigo-500" />
                            <span className="text-xs font-semibold">Bahasa Aplikasi</span>
                          </div>
                          <select 
                            value={language}
                            onChange={(e) => setLanguage(e.target.value as 'id' | 'en')}
                            className="bg-transparent text-xs font-bold focus:outline-none text-indigo-600 dark:text-indigo-400"
                          >
                            <option value="id" className="dark:text-zinc-800">Indonesian</option>
                            <option value="en" className="dark:text-zinc-800">English</option>
                          </select>
                        </div>

                        <div className="p-3.5 flex justify-between items-center">
                          <div className="flex items-center gap-2">
                            <Bell className="w-4 h-4 text-indigo-500" />
                            <span className="text-xs font-semibold">Push Notifikasi</span>
                          </div>
                          <button 
                            onClick={() => setIsNotifActive(!isNotifActive)}
                            className={`w-10 h-5.5 rounded-full p-0.5 transition-colors duration-200 focus:outline-none ${isNotifActive ? 'bg-indigo-600 flex justify-end' : 'bg-slate-300 flex justify-start'}`}
                          >
                            <span className="w-4.5 h-4.5 bg-white rounded-full shadow-md"></span>
                          </button>
                        </div>

                        <div className="p-3.5 flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <Info className="w-4 h-4 text-indigo-500" />
                            <span className="text-xs font-semibold">Tentang Aplikasi</span>
                          </div>
                          <span className="text-[10px] text-slate-400 font-mono">v1.2.4</span>
                        </div>
                      </div>

                      {/* REMINDERS LIST */}
                      <div className="bg-white dark:bg-zinc-800 p-4 rounded-3xl border border-slate-100 dark:border-zinc-700/50 shadow-xs space-y-2">
                        <span className="text-[10px] font-bold text-slate-400 uppercase tracking-widest block">Pengingat Berjadwal</span>
                        <div className="space-y-1.5Packed">
                          {reminders.map(rem => (
                            <div key={rem.id} className="flex justify-between items-center p-2.5 bg-slate-50 dark:bg-zinc-900 rounded-2xl">
                              <div>
                                <span className="font-bold text-xs block">{rem.title}</span>
                                <span className="text-[9px] text-slate-400 font-mono italic">{rem.type}</span>
                              </div>
                              <span className="text-[11px] font-mono font-bold text-indigo-600 dark:text-indigo-400">{rem.time} WIB</span>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* LOGOUT BUTTON */}
                      <button 
                        onClick={handleLogout}
                        className="w-full py-3 bg-rose-50 hover:bg-rose-100 dark:bg-red-950/20 text-rose-500 hover:text-rose-600 rounded-2xl text-xs font-bold flex items-center justify-center gap-1.5 transition"
                      >
                        <LogOut size={14} />
                        <span>Keluar Akun Simulasi</span>
                      </button>

                    </div>
                  )}

                </div>

                {/* BOTTOM NAVIGATION BAR */}
                <div className="bg-white dark:bg-zinc-900 border-t border-slate-100 dark:border-zinc-800 px-3 py-2.5 flex justify-between items-center">
                  <button 
                    onClick={() => {
                      setMenuIndex(0);
                      setIsNotifActive(p => {
                        if (p) alert("Navigasi ke Beranda");
                        return p;
                      });
                    }} 
                    className={`flex-1 flex flex-col items-center gap-1 ${menuIndex === 0 ? 'text-indigo-600' : 'text-slate-400'}`}
                  >
                    <BookOpen size={16} />
                    <span className="text-[9px] font-bold">Beranda</span>
                  </button>

                  <button 
                    onClick={() => setMenuIndex(1)} 
                    className={`flex-1 flex flex-col items-center gap-1 ${menuIndex === 1 ? 'text-indigo-600' : 'text-slate-400'}`}
                  >
                    <CalendarIcon size={16} />
                    <span className="text-[9px] font-bold">Jadwal</span>
                  </button>

                  <button 
                    onClick={() => setMenuIndex(2)} 
                    className={`flex-1 flex flex-col items-center gap-1 ${menuIndex === 2 ? 'text-indigo-600' : 'text-slate-400'}`}
                  >
                    <CheckSquare size={16} />
                    <span className="text-[9px] font-bold">Tugas</span>
                  </button>

                  <button 
                    onClick={() => setMenuIndex(3)} 
                    className={`flex-1 flex flex-col items-center gap-1 ${menuIndex === 3 ? 'text-indigo-600' : 'text-slate-400'}`}
                  >
                    <Clock size={16} />
                    <span className="text-[9px] font-bold">Kalender</span>
                  </button>

                  <button 
                    onClick={() => setMenuIndex(4)} 
                    className={`flex-1 flex flex-col items-center gap-1 ${menuIndex === 4 ? 'text-indigo-600' : 'text-slate-400'}`}
                  >
                    <Sparkles size={16} />
                    <span className="text-[9px] font-bold">Catatan</span>
                  </button>
                </div>
              </>
            )}

          </div>

        </div>

      </div>

      {/* RIGHT SIDE: FLUTTER CODE & DEVELOPMENT WORKSPACE VIEW */}
      {isFlutterDrawerOpen && (
        <div className="hidden lg:flex fixed top-0 right-0 bottom-0 w-[42%] bg-zinc-900 border-l border-zinc-800 flex-col z-30">
          
          {/* HEADER SECTION */}
          <div className="p-4 bg-zinc-950 border-b border-zinc-800 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Terminal className="text-emerald-400 w-5 h-5" />
              <div>
                <h3 className="text-white font-bold text-xs tracking-wide">Pusat Flutter VS Code</h3>
                <span className="text-[10px] text-zinc-400 block font-mono">Flutter Stable • Clean Arch</span>
              </div>
            </div>
            
            <button 
              onClick={() => setIsFlutterDrawerOpen(false)}
              className="p-1 hover:bg-zinc-800 text-zinc-500 hover:text-white rounded"
            >
              <X size={16} />
            </button>
          </div>

          {/* SPLIT VIEW LIST OF FILES & EDITOR */}
          <div className="flex-1 flex overflow-hidden">
            
            {/* FILE TREE SIDEBAR */}
            <div className="w-[180px] bg-zinc-950/80 border-r border-zinc-900 overflow-y-auto p-2 space-y-3 font-mono">
              <div>
                <span className="text-[9px] uppercase tracking-wider text-zinc-500 font-extrabold px-1 block mb-1">Daftar Berkas</span>
                <div className="space-y-0.5">
                  {Object.keys(flutterCodebase).map(filePath => {
                    const isSelected = selectedFlutterFile === filePath;
                    return (
                      <button
                        key={filePath}
                        onClick={() => setSelectedFlutterFile(filePath)}
                        className={`w-full text-[10px] text-left p-1 rounded transition truncate block cursor-pointer ${isSelected ? 'bg-indigo-600/20 text-indigo-300 font-bold border-l-2 border-indigo-500' : 'text-zinc-400 hover:bg-zinc-800/50 hover:text-white'}`}
                      >
                        {filePath.split('/').pop()}
                      </button>
                    );
                  })}
                </div>
              </div>
            </div>

            {/* EDITOR MAIN AREA */}
            <div className="flex-1 flex flex-col bg-zinc-900/45 overflow-hidden">
              <div className="bg-zinc-950 px-4 py-2 flex justify-between items-center border-b border-zinc-900/60 font-mono text-[10px]">
                <span className="text-zinc-500 truncate">{selectedFlutterFile}</span>
                <button 
                  onClick={() => handleCopyCode(flutterCodebase[selectedFlutterFile])}
                  className="bg-indigo-600 hover:bg-indigo-700 text-white px-2.5 py-1 rounded flex items-center gap-1 cursor-pointer transition font-sans"
                >
                  <Copy size={12} />
                  <span>Salin Code</span>
                </button>
              </div>

              {/* EDITOR PANEL */}
              <div className="flex-1 p-4 overflow-auto font-mono text-[11px] leading-relaxed text-zinc-300 select-all whitespace-pre">
                {flutterCodebase[selectedFlutterFile]}
              </div>
              
              {copiedNotification && (
                <div className="absolute right-4 bottom-4 bg-emerald-500 text-white font-sans text-xs px-4 py-2 rounded-xl shadow-lg flex items-center gap-1.5 animate-bounce z-50">
                  <CheckCircle size={14} />
                  <span>Kode berhasil disalin!</span>
                </div>
              )}
            </div>

          </div>

          {/* INSTRUCTIONS & DOWNLOAD FOOTER */}
          <div className="p-4 bg-zinc-950 border-t border-zinc-800 space-y-3">
            <div className="space-y-1">
              <span className="text-white font-bold text-xs uppercase block tracking-wider">Langkah Eksekusi di VS Code:</span>
              <ol className="list-decimal list-inside text-[10px] text-zinc-400 space-y-0.5 font-sans leading-relaxed">
                <li>Buka VS Code di sistem lokal komputer Anda.</li>
                <li>Jalankan perintah <code className="bg-zinc-800 text-yellow-400 px-1 rounded font-mono">flutter create jadwal_kuliah_pintar</code> di terminal.</li>
                <li>Sesuaikan file <code className="text-zinc-300 font-mono">pubspec.yaml</code> dari berkas sebelah kanan.</li>
                <li>Salin & buat file yang sama persis sesuai dengan struktur folder di atas.</li>
              </ol>
            </div>
            
            <div className="flex gap-2">
              <button 
                onClick={() => {
                  // Direct JSON download of full Flutter codebase
                  const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(flutterCodebase, null, 2));
                  const downloadAnchor = document.createElement('a');
                  downloadAnchor.setAttribute("href", dataStr);
                  downloadAnchor.setAttribute("download", "jadwal_kuliah_pintar_flutter_code.json");
                  document.body.appendChild(downloadAnchor);
                  downloadAnchor.click();
                  downloadAnchor.remove();
                }}
                className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-center gap-1 shadow-sm transition cursor-pointer"
              >
                <FileDown size={14} />
                <span>Unduh JSON Berkas Flutter</span>
              </button>
            </div>
          </div>

        </div>
      )}

      {/* REACT DIALOGS & MODALS */}
      
      {/* ADD SCHEDULE MODAL */}
      {isAddScheduleModalOpen && (
        <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white dark:bg-zinc-800 rounded-3xl w-full max-w-sm p-5 space-y-4 shadow-2xl">
            <h4 className="font-extrabold text-sm dark:text-white">Tambah Jadwal Kelas</h4>
            <form onSubmit={handleCreateSchedule} className="space-y-3 text-xs text-slate-800 dark:text-zinc-100">
              <div>
                <label className="block mb-1 font-bold">Nama Mata Kuliah</label>
                <input 
                  type="text" 
                  required
                  value={newSchedule.namaMatkul}
                  onChange={(e) => setNewSchedule({ ...newSchedule, namaMatkul: e.target.value })}
                  placeholder="e.g. Struktur Data"
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>
              <div>
                <label className="block mb-1 font-bold">Dosen Pengampu</label>
                <input 
                  type="text" 
                  required
                  value={newSchedule.dosen}
                  onChange={(e) => setNewSchedule({ ...newSchedule, dosen: e.target.value })}
                  placeholder="e.g. Dr. Eng Hermawan"
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block mb-1 font-bold">Ruangan</label>
                  <input 
                    type="text" 
                    required
                    value={newSchedule.ruangan}
                    onChange={(e) => setNewSchedule({ ...newSchedule, ruangan: e.target.value })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block mb-1 font-bold">Hari</label>
                  <select 
                    value={newSchedule.hari}
                    onChange={(e) => setNewSchedule({ ...newSchedule, hari: e.target.value })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                  >
                    {['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'].map(h => (
                      <option key={h} value={h}>{h}</option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block mb-1 font-bold">Mulai</label>
                  <input 
                    type="time" 
                    required
                    value={newSchedule.mulai}
                    onChange={(e) => setNewSchedule({ ...newSchedule, mulai: e.target.value })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none text-center"
                  />
                </div>
                <div>
                  <label className="block mb-1 font-bold">Selesai</label>
                  <input 
                    type="time" 
                    required
                    value={newSchedule.selesai}
                    onChange={(e) => setNewSchedule({ ...newSchedule, selesai: e.target.value })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none text-center"
                  />
                </div>
              </div>

              <div className="flex gap-2 pt-2">
                <button 
                  type="submit"
                  className="flex-1 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl"
                >
                  Simpan
                </button>
                <button 
                  type="button" 
                  onClick={() => setIsAddScheduleModalOpen(false)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl"
                >
                  Batal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ADD TASK MODAL */}
      {isAddTaskModalOpen && (
        <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white dark:bg-zinc-800 rounded-3xl w-full max-w-sm p-5 space-y-4 shadow-2xl">
            <h4 className="font-extrabold text-sm dark:text-white">Tambah Deadline Tugas</h4>
            <form onSubmit={handleCreateTask} className="space-y-3 text-xs text-slate-800 dark:text-zinc-100">
              <div>
                <label className="block mb-1 font-bold">Nama Tugas</label>
                <input 
                  type="text" 
                  required
                  value={newTask.namaTugas}
                  onChange={(e) => setNewTask({ ...newTask, namaTugas: e.target.value })}
                  placeholder="e.g. Lapres Algoritma"
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>
              <div>
                <label className="block mb-1 font-bold">Nama Mata Kuliah</label>
                <input 
                  type="text" 
                  required
                  value={newTask.namaMatkul}
                  onChange={(e) => setNewTask({ ...newTask, namaMatkul: e.target.value })}
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block mb-1 font-bold">Tanggal Deadline</label>
                  <input 
                    type="date" 
                    required
                    value={newTask.deadline}
                    onChange={(e) => setNewTask({ ...newTask, deadline: e.target.value })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block mb-1 font-bold">Prioritas</label>
                  <select 
                    value={newTask.prioritas}
                    onChange={(e) => setNewTask({ ...newTask, prioritas: e.target.value as any })}
                    className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                  >
                    <option value="Rendah">Rendah</option>
                    <option value="Sedang">Sedang</option>
                    <option value="Tinggi">Tinggi</option>
                  </select>
                </div>
              </div>
              <div>
                <label className="block mb-1 font-bold">Deskripsi Tambahan</label>
                <textarea 
                  rows={2}
                  value={newTask.deskripsi}
                  onChange={(e) => setNewTask({ ...newTask, deskripsi: e.target.value })}
                  placeholder="e.g. Bab 1 hingga 3 plus daftar pustaka format IEEE"
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button 
                  type="submit"
                  className="flex-1 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl"
                >
                  Simpan
                </button>
                <button 
                  type="button" 
                  onClick={() => setIsAddTaskModalOpen(false)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl"
                >
                  Batal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ADD NOTE MODAL */}
      {isAddNoteModalOpen && (
        <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white dark:bg-zinc-800 rounded-3xl w-full max-w-sm p-5 space-y-4 shadow-2xl">
            <h4 className="font-extrabold text-sm dark:text-white">Buat Catatan Kuliah</h4>
            <form onSubmit={handleCreateNote} className="space-y-3 text-xs text-slate-800 dark:text-zinc-100">
              <div>
                <label className="block mb-1 font-bold">Judul Catatan</label>
                <input 
                  type="text" 
                  required
                  value={newNote.judul}
                  onChange={(e) => setNewNote({ ...newNote, judul: e.target.value })}
                  placeholder="e.g. Catatan Docker & Ops"
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>
              <div>
                <label className="block mb-1 font-bold">Kategori</label>
                <select 
                  value={newNote.kategori}
                  onChange={(e) => setNewNote({ ...newNote, kategori: e.target.value as any })}
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                >
                  <option value="Pemrograman">Pemrograman</option>
                  <option value="Basis Data">Basis Data</option>
                  <option value="UI/UX">UI/UX</option>
                  <option value="Lainnya">Lainnya</option>
                </select>
              </div>
              <div>
                <label className="block mb-1 font-bold">Isi Catatan</label>
                <textarea 
                  rows={4}
                  required
                  value={newNote.isiCatatan}
                  onChange={(e) => setNewNote({ ...newNote, isiCatatan: e.target.value })}
                  className="w-full border dark:border-zinc-700 dark:bg-zinc-900 border-slate-200 px-3 py-2 rounded-xl focus:outline-none"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button 
                  type="submit"
                  className="flex-1 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl"
                >
                  Simpan Catatan
                </button>
                <button 
                  type="button" 
                  onClick={() => setIsAddNoteModalOpen(false)}
                  className="px-4 py-1.5 bg-slate-100 dark:bg-zinc-700 dark:text-zinc-100 dark:hover:bg-zinc-650 hover:bg-slate-200 text-slate-700 rounded-xl"
                >
                  Batal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* DETAIL TASK MODAL */}
      {isTaskModalOpen && selectedTask && (
        <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
          <div className="bg-white dark:bg-zinc-800 rounded-3xl w-full max-w-sm p-5 space-y-4 shadow-2xl text-xs">
            <div className="flex justify-between items-start pb-2 border-b dark:border-zinc-700 border-slate-100">
              <div>
                <span className="text-[10px] text-slate-400 block uppercase font-extrabold">{selectedTask.namaMatkul}</span>
                <h4 className="font-extrabold text-sm dark:text-textDark">{selectedTask.namaTugas}</h4>
              </div>
              <button onClick={() => setIsTaskModalOpen(false)} className="p-1 hover:bg-slate-100 dark:hover:bg-zinc-700 rounded">&times;</button>
            </div>
            
            <div className="space-y-2 dark:text-zinc-300">
              <div className="flex justify-between">
                <span className="font-semibold text-slate-400">Prioritas:</span>
                <span className="font-bold">{selectedTask.prioritas}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-400">Deadline:</span>
                <span className="font-bold">{selectedTask.deadline}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-400">Status pengerjaan:</span>
                <span className={`font-bold ${selectedTask.selesai ? 'text-emerald-500' : 'text-rose-500'}`}>{selectedTask.selesai ? 'Selesai' : 'Belum Selesai'}</span>
              </div>
              <div className="space-y-1 pt-1">
                <span className="font-semibold text-slate-400 block">Deskripsi:</span>
                <p className="bg-slate-50 dark:bg-zinc-900 p-2.5 rounded-xl text-slate-600 dark:text-zinc-400 italic leading-relaxed">{selectedTask.deskripsi || "Tidak ada deskripsi tambahan."}</p>
              </div>
            </div>

            <div className="flex gap-2 pt-2 justify-end">
              <button 
                onClick={() => {
                  handleToggleTask(selectedTask.id);
                  setIsTaskModalOpen(false);
                }}
                className={`flex-1 py-2 font-bold rounded-xl text-white ${selectedTask.selesai ? 'bg-amber-600' : 'bg-emerald-600'}`}
              >
                {selectedTask.selesai ? 'Tandai Belum' : 'Tandai Selesai'}
              </button>
              <button 
                onClick={() => handleDeleteTask(selectedTask.id)}
                className="px-4 py-2 bg-rose-500 text-white rounded-xl font-bold hover:bg-rose-600"
              >
                Hapus
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
