export interface Vaccination {
  id: string;
  name: string;
  date: number;
  location: string;
  batchNumber: string;
  nextDate?: number;
}

export interface HealthRecord {
  id: string;
  studentId: string;
  studentName: string;
  className: string;
  recordDate: number;
  height: number;
  weight: number;
  bmi: number;
  visionLeft: number;
  visionRight: number;
  temperature: number;
  bloodPressure: string;
  heartRate: number;
  vaccinations: Vaccination[];
  medicalHistory: string;
  allergies: string;
  healthStatus: 'healthy' | 'attention' | 'concern';
  updatedAt: number;
}
