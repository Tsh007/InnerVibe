import SwiftUI

struct DetailPranayamModel {
    
    var inhaleTime : Double
    var exhaleTime : Double
    var holdTime : Double?
    var sustainTime : Double?

    var instructions : [String]
    var benefits : [String]
    var tips : String
    var precautions : [String]
    
}

//souces for instructions , benefits , tips and precautions --  https://101yogasan.com/diarrhea/agnisar-kriya.htm
//https://www.artofliving.org/in-en/yoga/pranayama/bhastrika-pranayam
//https://www.healthline.com/health/fitness-exercise/ujjayi-breathing
//https://www.vinyasayogaashram.com/blog/ujjayi-pranayama-ujjayi-breathing-how-to-do-it-steps-and-benefits/
//https://www.pranawakening.com/post/sahita-kumbhaka-pranayama




var detailsPranayam : [String : DetailPranayamModel] = [
    "Agnisar" : DetailPranayamModel(inhaleTime: 3.0,
                                    exhaleTime: 5.0,
                                    holdTime: 12.0,
                                    sustainTime: nil,
                                    instructions: ["Sit in the Padmasana position and keep both your hands gently on your knees.","Close your eyes and focus on your normal breathing as you sit in this position.","Slowly exhale and then stop it outside. Put slight pressure as you keep your hands perfectly straight on your knees.","Start contracting and expanding your stomach as you try to touch your naval deep inside","Remain still in this same position as you inhale slowly. Keep on taking deep breaths as you stay stable."],
                                    benefits: ["Agnisar Kriya is one of the best asanas to strengthen the abdominal muscles.","Enhances digestive fire and metabolism","Increase lung capacity and respiratory health","Agnisar kriya helps to increase the blood flow within the body.","This practice can stimulate the pancreas and liver thus curing obesity problems."],
                                    tips: "Perform on an empty stomach for best results",
                                    precautions: ["Patients of a hernia, diarrhea, intestinal problems, and high blood pressure should never practice the Agnisar Kriya.","If you have recently undergone stomach operation, then you must not perform this kriya. Make sure that you start practicing it after at least a few months only under the professional guidance of a yoga master.","In case you experience feelings of physical distress and tiredness while practicing it, stop performing it immediately.","Patients having the ear, eye and nose problems must not practice this kriya."]),
    
    "Bhastrika" : DetailPranayamModel(inhaleTime: 2.0,
                                      exhaleTime: 2.0,
                                    holdTime: nil,
                                    sustainTime: nil,
                                    instructions: ["Sit in vajrasana or sukhasana (cross-legged position)","Makes a fist and fold your arms, placing them near your shoulders","Inhale deeply, raise your hands straight up and open your fists.","Exhale slightly forcefully, bring your arms down next to your shoulders and close your fists."],
                                    benefits: ["Great for energizing the body and mind.","Since we maximize our lung capacity while doing it, the pranayama helps remove toxins and impurities.","It helps in the sinus, bronchitis, and other respiratory issues.","Improved awareness, perceptive power of senses.","It helps balance doshas."],
                                    tips: "Perform on Vajrasana for best results",
                                    precautions: ["Make sure you practice it on an empty stomach.","Pregnant women should avoid it.","Do it at your own pace. If you feel dizzy, increase the duration of the breaks.","If you suffer from hypertension and panic disorders, then do it under the supervision of a teacher."]),
    
    "Bhramari" : DetailPranayamModel(inhaleTime: 5.0,
                                     exhaleTime: 10.0,
                                     holdTime: nil,
                                     sustainTime: nil,
                                     instructions: ["Sit up straight in a quiet, well-ventilated corner with your eyes closed. Keep a gentle smile on your face.","Keep your eyes closed for some time. Observe the sensations in the body and the quietness within.","Place your index fingers on your ears. There is a cartilage between your cheek and ear. Place your index fingers on the cartilage.","Take a deep breath in and as you breathe out, gently press the cartilage. ","You can keep the cartilage pressed or press it in and out with your fingers while making a loud humming sound like a bee.","You can also make a low-pitched sound but it is a good idea to make a high-pitched one for better results."],
                                     benefits: ["Gives instant relief from tension, anger and anxiety.","It is a very effective breathing technique for people suffering from hypertension .","Gives relief if you’re feeling hot or have a slight headache","Helps mitigate migraines.","Improves concentration and memory","Builds confidence.","Reduces blood pressure."],
                                     tips: "Bhramari is usually done after the warm-up at the start of the yoga practice.",
                                     precautions: ["Ensure that you are not putting your finger inside the ear but on the cartilage.","Don’t press the cartilage too hard. Gently press and release with the finger.","While making the humming sound, keep your mouth closed.","You can also do Bhramari pranayama with your fingers in the Shanmukhi Mudra.","Do not put pressure on your face.","Do not exceed the recommended repetitions of 3-4 times."]),
    
    "Ujjayi" : DetailPranayamModel(inhaleTime: 5.0,
                                   exhaleTime: 8.0,
                                   holdTime: nil,
                                   sustainTime: nil,
                                   instructions: ["Close your eyes and sit in any meditation posture like Padmasana","Keep your spine straight.","Take long, deep breaths slowly through your nose.","Then open your mouth and exhale slowly by making a “ha” sound.","Repeat several times."],
                                   benefits: ["The ability to concentrate increases.","This makes the body healthy and efficient.","With this practice, sinus and migraine problems can be overcome.","Along with making the voice melodious, this pranayama also keeps away from thyroid-like disease.","Works to reduce the chances of getting diseases like cough, indigestion, liver problems, dysentery, and fever."],
                                   tips: "You can also do Ujjayi when you are doing aerobic exercises like running or cycling.",
                                   precautions: ["Talk with your doctor before starting the practice if you have a medical condition such as asthma, COPD, or any other lung or heart concern.","If you feel adverse effects — such as shortness of breath — while doing the breathing technique, you should stop the practice immediately. This includes feeling lightheaded, dizzy, or nauseous.","If you find that the breathing is bringing up feelings of agitation or that it triggers any mental or physical symptoms, you should stop the practice."]),
    
    "Sahita" : DetailPranayamModel(inhaleTime: 4.0,
                                       exhaleTime: 15.0,
                                       holdTime: 6.0,
                                       sustainTime: 5.0,
                                       instructions: ["Sit in padmasana or in any meditative asana, spine should be straight.","Inhale slowly and longer as much as you can through the both nostrils.","The moment you realize/feel you cannot inhale anymore through the nostrils, then swallow the air through your lips (crow beak).","Use the tongue lock, then chin lock.","Hold the breath (antar kumbhaka) according to your capacity.","Then release the chin lock then tongue lock, and exhale deeply and longer by the both nostrils.","After this technique, 5 natural breathing."],
                                       benefits: ["Very good practice to increase the capacity of the lungs.","Develops physical strength in the body, making it fresh, active and strong. ","Increases beauty and shine on the face.","Makes the mind happy and calm. ","Mental problems are ended by this pranayama.","Appetite and thirst can be controlled.","Very useful for concentration and meditation."],
                                       tips: "Practice in the guidance of the teacher! ",
                                       precautions: ["Do not try if you have Heart problems,High blood pressure,Epilepsy ."])
]























