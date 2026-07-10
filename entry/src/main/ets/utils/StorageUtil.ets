import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const STORE_NAME = 'hwadee_fsc_prefs';

export class StorageUtil {
  private static ctx: Context;

  static init(context: Context): void {
    StorageUtil.ctx = context;
  }

  private static getStore(): Promise<preferences.Preferences> {
    return preferences.getPreferences(StorageUtil.ctx, STORE_NAME);
  }

  static async put(key: string, value: preferences.ValueType): Promise<void> {
    const store = await StorageUtil.getStore();
    await store.put(key, value);
    await store.flush();
  }

  static async get<T extends preferences.ValueType>(key: string, def: T): Promise<T> {
    const store = await StorageUtil.getStore();
    return store.get(key, def) as Promise<T>;
  }

  static async remove(key: string): Promise<void> {
    const store = await StorageUtil.getStore();
    await store.delete(key);
    await store.flush();
  }

  static async has(key: string): Promise<boolean> {
    const store = await StorageUtil.getStore();
    return store.has(key);
  }
}
