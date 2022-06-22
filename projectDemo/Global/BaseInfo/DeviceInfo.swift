//
//  DeviceInfo.swift
//  projectDemo
//
//  Created by Cheng on 2022/6/20.
//

import Foundation
import AdSupport
import CoreTelephony
import MachO

class DeviceInfo {

    ///获取系统版本
    public static func deviceSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    ///获取设备的型号
    public static func deviceModel() -> String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        switch platform {
            
        //iPhone
        case "iPhone7,2":                   return "iPhone 6"
        case "iPhone7,1":                   return "iPhone 6 Plus"
        case "iPhone8,1":                   return "iPhone 6s"
        case "iPhone8,2":                   return "iPhone 6s Plus"
        case "iPhone8,4":                   return "iPhone SE (1st generation)"
        case "iPhone9,1", "iPhone9,3":      return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":      return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":     return "iPhone 8"
        case "iPhone10,2","iPhone10,5":     return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":     return "iPhone X"
        case "iPhone11,8":                  return "iPhone XR"
        case "iPhone11,2":                  return "iPhone XS"
        case "iPhone11,6", "iPhone11,4":    return "iPhone XS Max"
        case "iPhone12,1":                  return "iPhone 11"
        case "iPhone12,3":                  return "iPhone 11 Pro"
        case "iPhone12,5":                  return "iPhone 11 Pro Max"
        case "iPhone12,8":                  return "iPhone SE (2nd generation)"
        case "iPhone13,1":                  return "iPhone 12 mini"
        case "iPhone13,2":                  return "iPhone 12"
        case "iPhone13,3":                  return "iPhone 12 Pro"
        case "iPhone13,4":                  return "iPhone 12 Pro Max"
        case "iPhone14,4":                  return "iPhone 13 mini"
        case "iPhone14,5":                  return "iPhone 13"
        case "iPhone14,2":                  return "iPhone 13 Pro"
        case "iPhone14,3":                  return "iPhone 13 Pro Max"
        case "iPhone14,6":                  return "iPhone SE (3rd generation)"
            
        //iPad
        case "iPad1,1":                                     return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":    return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":               return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":               return "iPad (4th generation)"
        case "iPad6,11", "iPad6,12":                        return "iPad (5th generation)"
        case "iPad7,5", "iPad7,6":                          return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":                        return "iPad (7th generation)"
        case "iPad11,6", "iPad11,7":                        return "iPad (8th generation)"
        case "iPad12,1", "iPad12,2":                        return "iPad (9th generation)"
        //iPad Air
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad5,3", "iPad5,4":              return "iPad Air 2"
        case "iPad11,3", "iPad11,4":            return "iPad Air (3rd generation)"
        case "iPad13,1", "iPad13,2":            return "iPad Air (4th generation)"
        case "iPad13,6", "iPad13,7":            return "iPad Air (5th generation)"
        //iPad Pro
        case "iPad6,7", "iPad6,8":                              return "iPad Pro (12.9-inch)"
        case "iPad6,3", "iPad6,4":                              return "iPad Pro (9.7-inch)"
        case "iPad7,1", "iPad7,2":                              return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                              return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3":                   return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad7,8":        return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,9", "iPad8,10":                             return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,11", "iPad8,12":                            return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad13,4", "iPad13,5":                            return "iPad Pro (11-inch) (3rd generation)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPad Pro (12.9-inch) (5th generation)"
        //iPad mini
        case "iPad2,5", "iPad2,6", "iPad2,7":   return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":   return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":   return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":              return "iPad Mini 4"
        case "iPad11,1", "iPad11,2":            return "iPad mini (5th generation)"
        case "iPad14,1", "iPad14,2":            return "iPad mini (6th generation)"
            
        case "i386", "x86_64":  return "Simulator"
        default:
            return platform
        }
    }

    ///获取屏幕尺寸
    public static func deviceResolution() -> String {
        return "\(UIScreen.main.bounds.width) * \(UIScreen.main.bounds.height)";
    }

    ///获取运营商
    public static func deviceSupplier() -> String {
        let info = CTTelephonyNetworkInfo()
        var supplier:String = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.count == 0 {
                    return "无手机卡"
                } else { //获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else { return "无手机卡" }
                        //查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                           supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else{
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else { return "无手机卡" }
                return carrier.carrierName!
            } else{
                return "无手机卡"
            }
        }
    }
    
    ///获取当前设备IP
    public static func deviceIP() -> String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        if let ipStr = addresses.first {
            return ipStr
        } else {
            return ""
        }
    }
    
    ///获取cpu核数
    public static func deviceCpuCount() -> Int {
        var ncpu: UInt = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }
    
    ///获取cpu类型
    public static func deviceCpuType() -> String {
        
        let HOST_BASIC_INFO_COUNT = MemoryLayout<host_basic_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_BASIC_INFO_COUNT)
        var hostInfo = host_basic_info()
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity:Int(size)){
                host_info(mach_host_self(), Int32(HOST_BASIC_INFO), $0, &size)
            }
        }
        print(result, hostInfo)
        switch hostInfo.cpu_type {
        case CPU_TYPE_ARM:
            return "CPU_TYPE_ARM"
        case CPU_TYPE_ARM64:
            return "CPU_TYPE_ARM64"
        case CPU_TYPE_ARM64_32:
            return"CPU_TYPE_ARM64_32"
        case CPU_TYPE_X86:
            return "CPU_TYPE_X86"
        case CPU_TYPE_X86_64:
            return"CPU_TYPE_X86_64"
        case CPU_TYPE_ANY:
            return"CPU_TYPE_ANY"
        case CPU_TYPE_VAX:
            return"CPU_TYPE_VAX"
        case CPU_TYPE_MC680x0:
            return"CPU_TYPE_MC680x0"
        case CPU_TYPE_I386:
            return"CPU_TYPE_I386"
        case CPU_TYPE_MC98000:
            return"CPU_TYPE_MC98000"
        case CPU_TYPE_HPPA:
            return"CPU_TYPE_HPPA"
        case CPU_TYPE_MC88000:
            return"CPU_TYPE_MC88000"
        case CPU_TYPE_SPARC:
            return"CPU_TYPE_SPARC"
        case CPU_TYPE_I860:
            return"CPU_TYPE_I860"
        case CPU_TYPE_POWERPC:
            return"CPU_TYPE_POWERPC"
        case CPU_TYPE_POWERPC64:
            return"CPU_TYPE_POWERPC64"
        default:
            return ""
        }
    }

    ///磁盘可用大小
    public static func deviceTotalDiskSize() -> String {
        
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return fileSizeToString(fileSize: Int64(UInt64(fs.f_bsize) * fs.f_bavail))
        }
        return "-1"
    }
    
    ///获取CPU使用率
    public static func deviceCPUUsage() -> Double {
        var kr: kern_return_t
        var task_info_count: mach_msg_type_number_t

        task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))

        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
        if kr != KERN_SUCCESS {
            return -1
        }
        
        var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
        
        var thread_count: mach_msg_type_number_t = 0
        defer {
            if let thread_list = thread_list {
                vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
            }
        }

        kr = task_threads(mach_task_self_, &thread_list, &thread_count)

        if kr != KERN_SUCCESS {
            return -1
        }

        var tot_cpu: Double = 0

        if let thread_list = thread_list {

            for j in 0 ..< Int(thread_count) {
                var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                                 &thinfo, &thread_info_count)
                if kr != KERN_SUCCESS {
                    return -1
                }

                let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)

                if threadBasicInfo.flags != TH_FLAGS_IDLE {
                    tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            } // for each thread
        }

        return tot_cpu
    }
    
    ///内存可用大小
    public static func deviceAvailableMemorySize() -> String {

        var usedMemory: Int64 = 0
        
        let hostPort: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        var pagesize:vm_size_t = 0
        host_page_size(hostPort, &pagesize)
        var vmStat: task_vm_info_data_t = task_vm_info_data_t()
        let status: kern_return_t = withUnsafeMutablePointer(to: &vmStat) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &host_size)
            }
        }
        if status == KERN_SUCCESS {
 
            usedMemory = (Int64)(vmStat.phys_footprint)
            let total = (Int64)(ProcessInfo.processInfo.physicalMemory)
            return fileSizeToString(fileSize: (Int64)(total) - usedMemory)
        }
        else {
            return "0"
        }
        
//        let memoryUsageInByte:Int64 = 0
//        var vmInfo: task_vm_info_data_t
//        vmInfo = task_vm_info_data_t()
//        var count:mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
//        let kr = withUnsafeMutablePointer(to: &vmInfo) { infoPtr in
//             infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
//                 task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
//             }
//         }
//            if kr == KERN_SUCCESS {
//                memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
//            } else {
//                NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
//            }
//            return memoryUsageInByte;
    }
    
    
    ///将大小转换成字符串用以显示
    public static func fileSizeToString(fileSize:Int64) -> String {
        
        let fileSize1 = CGFloat(fileSize)
        
        let KB:CGFloat = 1024
        let MB:CGFloat = KB*KB
        let GB:CGFloat = MB*KB
        
        if fileSize < 10 {
            return "0 B"
        } else if fileSize1 < KB {
            return "< 1 KB"
        } else if fileSize1 < MB {
            return String(format: "%.1f KB", CGFloat(fileSize1)/KB)
        } else if fileSize1 < GB {
            return String(format: "%.1f MB", CGFloat(fileSize1)/MB)
        } else {
            return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        }
    }

    public static func blankof<T>(type:T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        return val
    }
    
    public static func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
        var result = thread_basic_info()

        result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
        result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
        result.cpu_usage = threadInfo[4]
        result.policy = threadInfo[5]
        result.run_state = threadInfo[6]
        result.flags = threadInfo[7]
        result.suspend_count = threadInfo[8]
        result.sleep_time = threadInfo[9]

        return result
    }
}

