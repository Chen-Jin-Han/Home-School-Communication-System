export interface Vaccination {
  id: string;
  name: string;
  date: number | string;
  location: string;
  batchNumber: string;
  nextDate?: number | string;
}

export interface HealthRecord {
  id: string;
  studentId: string;
  studentName: string;
  className: string;
  recordDate: number | string;
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
  updatedAt: number | string;
}
